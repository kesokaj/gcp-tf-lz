output "project_id" {
  description = "The ID of the created project."
  value       = module.project.project_id
}

output "project_name" {
  description = "The name of the created project."
  value       = module.project.project_name
}

output "project_number" {
  description = "The number of the created project."
  value       = module.project.project_number
}

output "project_alias" {
  description = "The alias of the created project."
  value       = module.project.alias
}

output "project_alias_id" {
  description = "The alias ID of the created project."
  value       = module.project.alias_id
}

output "project_org_id" {
  description = "The organization ID of the created project."
  value       = module.project.org_id
}

output "network_vpc_name" {
  description = "The name of the created VPC."
  value       = module.network.vpc
}

output "network_vpc_id" {
  description = "The ID of the created VPC."
  value       = module.network.vpc_id
}

output "regions" {
  description = "A list of the created regions."
  value       = var.regions
}
