output "project_id" {
  value = google_project.project.project_id
}

output "project_name" {
  value = google_project.project.name
}

output "project_number" {
  value = google_project.project.number
}

output "alias" {
  value = "${random_pet.project_prefix.id}-${random_string.project_suffix.id}"
}

output "alias_id" {
  value = random_string.project_suffix.id
}

output "org_id" {
  value = google_project.project.org_id
}