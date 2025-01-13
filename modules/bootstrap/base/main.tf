resource "random_string" "x" {
  length = 2
  special = false
  upper = false
  lower = true
  numeric = false
}

resource "random_integer" "x" {
  min = 10
  max = 99
}

resource "random_pet" "x" {
  length = 1
}
resource "google_project" "x" {
  name            = "${random_string.x.id}${random_integer.x.id}-${random_pet.x.id}"
  project_id      = "${random_string.x.id}${random_integer.x.id}-${random_pet.x.id}"
  billing_account = var.billing_id
  org_id          = var.org_id
  deletion_policy = "DELETE"
}

resource "google_project_service" "x" {
  for_each                   = toset(var.service_list)
  project                    = google_project.x.project_id
  service                    = each.value
  disable_on_destroy         = false
  disable_dependent_services = false
}

resource "google_project_organization_policy" "x" {
  depends_on = [
    google_project_service.x
  ]
  for_each = toset(var.org_policy_list)
  project    = google_project.x.project_id
  constraint = each.value

  restore_policy {
    default = true
  }
}

resource "google_service_account" "minimal_sa" {
  depends_on = [
    google_project.x,
    google_project_service.x
  ]
  project = google_project.x.project_id
  account_id   = "minimal-sa-${google_project.x.number}"
  display_name = "Minimal SA"
}

resource "google_project_iam_member" "compute_sa_role" {
  depends_on = [
    google_project.x,
    google_project_service.x
  ]
  project = google_project.x.project_id
  role    = "roles/owner"
  member = "serviceAccount:${google_project.x.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "minimal_sa_role" {
  for_each = toset([
    "roles/logging.bucketWriter",
    "roles/monitoring.metricWriter",
    "roles/cloudtrace.agent",
    "roles/cloudsql.client",
    "roles/cloudprofiler.agent",
    "roles/storage.objectViewer"
  ])
  role = each.key
  member = "serviceAccount:${google_service_account.minimal_sa.email}"
  project = google_project.x.project_id
}

