module "ecs" {
  source = "../../modules/ecs"

  region      = var.region
  environment = var.environment
  name_prefix = local.name_prefix

  application_name = var.application_name
  application_port = var.application_port

  ecr_repository_url = module.ecr.repository_url
  target_group_arn   = module.alb.target_group_arn

  db_resource_id = module.rds.resource_id
  db_username    = var.db_username
  db_host        = module.rds.address
  db_name        = var.db_name

  vpc_id     = module.vpc.id
  subnet_ids = module.vpc.private_subnet_ids
}

resource "aws_security_group_rule" "ecs_ingress_from_alb" {
  type              = "ingress"
  security_group_id = module.ecs.security_group_id

  from_port = var.application_port
  to_port   = var.application_port
  protocol  = "tcp"

  source_security_group_id = module.alb.security_group_id
}

resource "aws_security_group_rule" "ecs_egress_to_vpce" {
  type              = "egress"
  security_group_id = module.ecs.security_group_id

  from_port = var.https_port
  to_port   = var.https_port
  protocol  = "tcp"

  source_security_group_id = module.vpc.vpce_security_group_id
}

resource "aws_security_group_rule" "ecs_egress_to_s3" {
  type              = "egress"
  security_group_id = module.ecs.security_group_id

  from_port = var.https_port
  to_port   = var.https_port
  protocol  = "tcp"

  prefix_list_ids = [data.aws_ec2_managed_prefix_list.s3.id]
}

resource "aws_security_group_rule" "ecs_egress_to_rds" {
  type              = "egress"
  security_group_id = module.ecs.security_group_id

  from_port = var.postgres_port
  to_port   = var.postgres_port
  protocol  = "tcp"

  source_security_group_id = module.rds.security_group_id
}
