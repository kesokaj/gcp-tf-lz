output "project_id" {
  value = google_project.x.project_id
}

output "project_name" {
  value = google_project.x.name
}

output "project_number" {
  value = google_project.x.number
}

output "alias" {
  value = "${random_string.x.id}${random_integer.x.id}-${random_pet.x.id}"
}

output "alias_id" {
  value = "${random_string.x.id}${random_integer.x.id}"
}

output "org_id" {
  value = google_project.x.org_id
}