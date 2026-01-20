module "alb" {
  source = "../../modules/alb"

  name_prefix = local.name_prefix

  application_port = var.application_port

  vpc_id     = module.vpc.id
  subnet_ids = module.vpc.public_subnet_ids
}

resource "aws_security_group_rule" "alb_ingress_from_cloudfront" {
  type              = "ingress"
  security_group_id = module.alb.security_group_id

  from_port = var.http_port
  to_port   = var.http_port
  protocol  = "tcp"

  prefix_list_ids = [
    data.aws_ec2_managed_prefix_list.cloudfront.id
  ]
}

resource "aws_security_group_rule" "alb_egress_to_ecs" {
  type              = "egress"
  security_group_id = module.alb.security_group_id

  from_port = var.application_port
  to_port   = var.application_port
  protocol  = "tcp"

  source_security_group_id = module.ecs.security_group_id
}
