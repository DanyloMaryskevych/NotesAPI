# Notes API - Deployment Guide

## Prerequisites

```bash
terraform --version   # >= 1.0
aws --version         # >= 2.0
docker --version      # >= 20.0

# Verify AWS credentials
aws sts get-caller-identity
```

---

## 1. Deploy Infrastructure

```bash
cd terraform/envs/staging

terraform init
terraform plan
terraform apply   # ~10-15 minutes
```

**Save these outputs:**
- `rds_endpoint` - Database hostname
- `rds_master_password_secret_arn` - Secret ARN for master password
- `route53_name_servers` - NS records for DNS delegation

---

## 2. DNS Configuration (Cloudflare → Route53)

**Step 1:** Get Route53 name servers:
```bash
terraform output route53_name_servers
```

**Step 2:** In Cloudflare, add NS records:

| Type | Name | Content |
|------|------|---------|
| NS | notes | ns-1234.awsdns-12.org |
| NS | notes | ns-567.awsdns-34.com |
| NS | notes | ns-890.awsdns-56.co.uk |
| NS | notes | ns-111.awsdns-78.net |

**Step 3:** Verify propagation:
```bash
dig notes.cloud-concepts.org NS +short
```

---

## 3. Database Setup (EC2 Bastion)

RDS is in a private subnet. Use a bastion host to configure the database.

### 3.1 Launch Bastion EC2

```bash
# Get VPC and subnet IDs
VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=notes-staging-vpc" \
  --query 'Vpcs[0].VpcId' --output text)

SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=tag:Name,Values=notes-staging-subnet-public-1" \
  --query 'Subnets[0].SubnetId' --output text)

# Create bastion security group
BASTION_SG=$(aws ec2 create-security-group \
  --group-name notes-staging-bastion-sg \
  --description "Bastion host for DB access" \
  --vpc-id $VPC_ID \
  --query 'GroupId' --output text)

# Allow SSH from your IP
aws ec2 authorize-security-group-ingress \
  --group-id $BASTION_SG \
  --protocol tcp \
  --port 22 \
  --cidr $(curl -s ifconfig.me)/32

# Launch instance (Amazon Linux 2023, eu-north-1)
aws ec2 run-instances \
  --image-id ami-075449515af5df0d1 \
  --instance-type t3.micro \
  --subnet-id $SUBNET_ID \
  --security-group-ids $BASTION_SG \
  --associate-public-ip-address \
  --key-name your-key-pair \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=notes-staging-bastion}]'
```

### 3.2 Allow Bastion → RDS Connection

```bash
RDS_SG=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=notes-staging-rds-sg" \
  --query 'SecurityGroups[0].GroupId' --output text)

aws ec2 authorize-security-group-ingress \
  --group-id $RDS_SG \
  --protocol tcp \
  --port 5432 \
  --source-group $BASTION_SG
```

### 3.3 Connect to Bastion

```bash
ssh -i your-key.pem ec2-user@<bastion-public-ip>

# Install PostgreSQL client
sudo dnf install -y postgresql15
```

### 3.4 Get RDS Master Password

```bash
aws secretsmanager get-secret-value \
  --secret-id <rds_master_password_secret_arn> \
  --query 'SecretString' --output text | jq -r '.password'
```

### 3.5 Create IAM Database User

```bash
psql -h <rds-endpoint> -U postgres -d notes
```

```sql
-- Create IAM-authenticated user
CREATE USER notes_user WITH LOGIN;
GRANT rds_iam TO notes_user;

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE notes TO notes_user;
GRANT ALL ON SCHEMA public TO notes_user;

-- For future tables (migrations)
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT ALL ON TABLES TO notes_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT ALL ON SEQUENCES TO notes_user;

-- Verify
\du notes_user
```

### 3.6 Cleanup Bastion

```bash
# Terminate instance
aws ec2 terminate-instances --instance-ids <instance-id>

# Delete security group (after instance terminates)
aws ec2 delete-security-group --group-id $BASTION_SG

# Remove rule from RDS security group
aws ec2 revoke-security-group-ingress \
  --group-id $RDS_SG \
  --protocol tcp \
  --port 5432 \
  --source-group $BASTION_SG
```

---

## 4. Configure GitHub Actions

**Step 1:** Get role ARN:
```bash
terraform output github_role_arn
```

**Step 2:** Add GitHub repository variable:
- Repository → Settings → Secrets and variables → Actions → Variables
- Name: `AWS_ROLE_ARN`
- Value: `arn:aws:iam::321298294759:role/github-actions-notes-staging`

**Step 3:** Push to deploy:
```bash
git push origin master
```

---

## 5. Verify Deployment

```bash
# Check ECS service
aws ecs describe-services \
  --cluster notes-staging \
  --services notes-staging \
  --query 'services[0].{status:status,running:runningCount,desired:desiredCount}'

# Test application
curl https://notes.cloud-concepts.org/api/health
```

---

## Cost Breakdown

| Resource | Configuration | Est. Monthly Cost |
|----------|---------------|-------------------|
| RDS PostgreSQL | db.t4g.micro, 20 GB, single-AZ | ~$13-15 |
| ECS Fargate | 0.25 vCPU, 512 MB, 1 task | ~$9-10 |
| ALB | Application Load Balancer | ~$16-18 |
| VPC Endpoints | 4 interface endpoints | ~$29 |
| CloudFront | Distribution + requests | ~$1-5 |
| WAF | 1 Web ACL + 4 rules | ~$7 |
| Route53 | 1 hosted zone | $0.50 |
| CloudWatch Logs | 14-day retention | ~$0.50-2 |
| Lambda | 128 MB, minimal invocations | Free |
| ACM Certificate | SSL/TLS | Free |
| **Total** | | **~$75-90/month** |
