# Global / Environment
region      = "eu-north-1"
project     = "notes"
environment = "staging"

# Networking
vpc_cidr    = "10.0.0.0/16"
azs_count   = 3
hosted_zone = "cloud-concepts.org"

# Application
application_name = "api"
application_port = 3000

# Database
db_name        = "notes"
db_username    = "notes_user"
instance_class = "db.t4g.micro"

rds_allocated_storage_gb = 20

# OIDC
github_org  = "DanyloMaryskevych"
github_repo = "NotesAPI"
github_ref  = "ref:refs/heads/main"
