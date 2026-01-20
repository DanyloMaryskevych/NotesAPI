output "db_instance_identifier" {
  value = aws_db_instance.this.id
}

output "resource_id" {
  value = aws_db_instance.this.resource_id
}

output "security_group_id" {
  value = aws_security_group.rds.id
}

output "endpoint" {
  value = aws_db_instance.this.endpoint
}

output "address" {
  value = aws_db_instance.this.address
}
