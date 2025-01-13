variable "project_id" {
  type = string
}

variable "alias" {
  type = string
}

variable "alias_id" {
  type = string
}

variable "vpc_config" {
  type        = map(any)
  description = "Regions for VPC Subnets to be created"
}

variable "firewall_config" {
  type        = map(any)
  description = "Firewall rules in VPC"
}

variable "peer_allocation" {
  type = string
  description = "Peering network for different services a /20 will be used"
}

variable "logs_config" {
  type = map(any)
  description = "Logging configuration for VPC"
}