variable "project_id" {
  type        = string
  description = "The ID of the project where the network will be created."
}

variable "alias" {
  type        = string
  description = "A human-readable alias for the network."
}

variable "alias_id" {
  type        = string
  description = "A unique ID for the network alias."
}

variable "firewall_config" {
  type = map(object({
    protocol = list(string)
    ports    = list(string)
    tags     = list(string)
    source   = list(string)
    logs     = string
    priority = string
  }))
  description = "A map of firewall rules to be created in the VPC. The keys are the rule names and the values are the rule configurations."
}

variable "peer_allocation" {
  type        = string
  description = "The /20 CIDR block to be reserved for peering with other services."
}

variable "logs_config" {
  type = object({
    subnet = object({
      interval = string
      samples  = number
      metadata = string
    })
    router = object({
      enable = bool
      filter = string
    })
  })
  description = "A map of logging configurations for the VPC. The keys are the log types (e.g., 'subnet', 'router') and the values are the logging configurations."
}

variable "vpc_supernet_cidr" {
  type        = string
  description = "The supernet CIDR block for the VPC. This will be divided into smaller subnets for each region."
}

variable "regions" {
  type        = list(string)
  description = "A list of GCP regions where the VPC and subnets will be created."
}

variable "router_asn" {
  type        = number
  description = "The BGP ASN for the Cloud Router."
}

variable "network_mtu" {
  type        = number
  description = "The MTU of the VPC network."
}

variable "subnet_layout" {
  description = "Describes the layout of secondary subnets within each region's supernet."
  type = map(object({
    newbits = number
    netnum  = number
  }))
  default = {
    "services" = { newbits = 4, netnum = 1 }
    "pods"     = { newbits = 1, netnum = 1 }
    "psc"      = { newbits = 10, netnum = 16 }
    "glproxy"  = { newbits = 9, netnum = 10 }
    "rmproxy"  = { newbits = 9, netnum = 11 }
    "pnat"     = { newbits = 8, netnum = 6 }
  }
}

variable "primary_subnet_newbits" {
  description = "The number of new bits to use for the primary subnet within the region's supernet."
  type        = number
  default     = 6
}

variable "region_supernet_newbits" {
  description = "The number of new bits to use for each region's supernet within the VPC supernet."
  type        = number
  default     = 8
}