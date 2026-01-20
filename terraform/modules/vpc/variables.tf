variable "region" {
  type        = string
  description = "AWS region where resources will be created"
}

variable "name_prefix" {
  type        = string
  description = "Global resource name prefix (e.g. myapp-prod)"
}

variable "cidr_block" {
  type        = string
  description = "VPC cidr block"
}

variable "azs_count" {
  type        = number
  description = "Number of Availability Zones to use for the VPC subnets."
}
