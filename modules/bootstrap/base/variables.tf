variable "org_id" {
  type = string
}

variable "billing_id" {
  type = string
}

variable "org_policy_list" {
  type = list(any)
}

variable "service_list" {
  type = list(any)
}