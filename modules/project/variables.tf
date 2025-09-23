variable "org_id" {
  type        = string
  description = "The ID of the organization to which the project belongs."
}

variable "billing_id" {
  type        = string
  description = "The ID of the billing account to be associated with the project."
}

variable "org_policy_list" {
  type        = list(string)
  description = "A list of organization policies to be applied to the project."
}

variable "service_list" {
  type        = list(string)
  description = "A list of APIs to be enabled on the project."
}