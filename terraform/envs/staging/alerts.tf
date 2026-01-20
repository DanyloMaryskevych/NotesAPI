# ECS

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name        = "${local.name_prefix}-ecs-cpu-high"
  alarm_description = "ECS CPU > 80%"

  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    ClusterName = module.ecs.cluster_name
    ServiceName = module.ecs.service_name
  }

  alarm_actions = [module.sns.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  alarm_name        = "${local.name_prefix}-ecs-memory-high"
  alarm_description = "ECS memory > 80%"

  namespace           = "AWS/ECS"
  metric_name         = "MemoryUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    ClusterName = module.ecs.cluster_name
    ServiceName = module.ecs.service_name
  }

  alarm_actions = [module.sns.sns_topic_arn]
}

# ALB

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name        = "${local.name_prefix}-alb-5xx"
  alarm_description = "ALB target 5XX errors"

  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = module.alb.arn_suffix
  }

  alarm_actions = [module.sns.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "alb_latency_high" {
  alarm_name        = "${local.name_prefix}-alb-latency-high"
  alarm_description = "ALB latency > 1s"

  namespace           = "AWS/ApplicationELB"
  metric_name         = "TargetResponseTime"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 3
  threshold           = 1
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = module.alb.arn_suffix
  }

  alarm_actions = [module.sns.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name        = "${local.name_prefix}-alb-unhealthy-targets"
  alarm_description = "ALB unhealthy targets > 0"

  namespace           = "AWS/ApplicationELB"
  metric_name         = "UnHealthyHostCount"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 2
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = module.alb.arn_suffix
    TargetGroup  = module.alb.target_group_arn_suffix
  }

  alarm_actions = [module.sns.sns_topic_arn]
}

# RDS

resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name        = "${local.name_prefix}-rds-cpu-high"
  alarm_description = "RDS CPU > 75%"

  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 75
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_identifier
  }

  alarm_actions = [module.sns.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  alarm_name        = "${local.name_prefix}-rds-low-storage"
  alarm_description = "RDS free storage below ${var.rds_min_free_storage_percent}%"

  namespace           = "AWS/RDS"
  metric_name         = "FreeStorageSpace"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = local.rds_min_free_storage_bytes
  comparison_operator = "LessThanThreshold"

  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_identifier
  }

  alarm_actions = [module.sns.sns_topic_arn]
}

# Cloudfront

resource "aws_cloudwatch_metric_alarm" "cloudfront_5xx" {
  alarm_name        = "${local.name_prefix}-cloudfront-5xx"
  alarm_description = "CloudFront 5XX error rate > 1%"

  namespace           = "AWS/CloudFront"
  metric_name         = "5xxErrorRate"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    DistributionId = module.cloudfront.distribution_id
    Region         = "Global"
  }

  alarm_actions = [module.sns.sns_topic_arn]
}

