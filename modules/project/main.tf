resource "random_string" "project_suffix" {
  length  = 4
  special = false
  upper   = false
  lower   = true
  numeric = true
}

resource "random_pet" "project_prefix" {
  length = 2
}

resource "google_project" "project" {
  name            = "${random_pet.project_prefix.id}-${random_string.project_suffix.id}"
  project_id      = "${random_pet.project_prefix.id}-${random_string.project_suffix.id}"
  billing_account = var.billing_id
  org_id          = var.org_id
  deletion_policy = "DELETE"
}

resource "google_project_service" "project_services" {
  for_each                   = toset(var.service_list)
  project                    = google_project.project.project_id
  service                    = each.value
  disable_on_destroy         = false
  disable_dependent_services = false
}

resource "google_project_organization_policy" "project_org_policies" {
  depends_on = [
    google_project_service.project_services
  ]
  for_each   = toset(var.org_policy_list)
  project    = google_project.project.project_id
  constraint = each.value

  restore_policy {
    default = true
  }
}


resource "google_project_iam_member" "compute_sa_role" {
  depends_on = [
    google_project.project,
    google_project_service.project_services
  ]
  project = google_project.project.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_project.project.number}-compute@developer.gserviceaccount.com"
}