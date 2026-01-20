module "rds" {
  source = "../../modules/rds"

  name_prefix = local.name_prefix

  db_name           = var.db_name
  instance_class    = var.instance_class
  allocated_storage = var.rds_allocated_storage_gb

  vpc_id     = module.vpc.id
  subnet_ids = module.vpc.private_subnet_ids
}

resource "aws_security_group_rule" "rds_ingress_from_ecs" {
  type              = "ingress"
  security_group_id = module.rds.security_group_id

  from_port = var.postgres_port
  to_port   = var.postgres_port
  protocol  = "tcp"

  source_security_group_id = module.ecs.security_group_id
}