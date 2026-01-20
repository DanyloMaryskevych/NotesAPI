# Temporary bastion for DB setup - delete after use

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "bastion" {
  name   = "${local.name_prefix}-bastion-sg"
  vpc_id = module.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "rds_ingress_from_bastion" {
  type              = "ingress"
  security_group_id = module.rds.security_group_id

  from_port = var.postgres_port
  to_port   = var.postgres_port
  protocol  = "tcp"

  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.bastion.key_name

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y postgresql15
  EOF

  tags = {
    Name = "${local.name_prefix}-bastion"
  }
}

resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion" {
  key_name   = "${local.name_prefix}-bastion-key"
  public_key = tls_private_key.bastion.public_key_openssh
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_private_key" {
  value     = tls_private_key.bastion.private_key_pem
  sensitive = true
}

output "rds_endpoint" {
  value = module.rds.endpoint
}
