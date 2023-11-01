resource "random_pet" "x" {
  length = 2
  prefix = "xyz"
}
resource "google_project" "x" {
  name            = random_pet.x.id
  project_id      = random_pet.x.id
  billing_account = var.billing_id
  org_id          = var.org_id
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

resource "google_project_iam_member" "compute_svc_default" {
  depends_on = [
    google_project.x,
    google_project_service.x
  ]
  project = google_project.x.project_id
  role    = "roles/owner"
  member = "serviceAccount:${google_project.x.number}-compute@developer.gserviceaccount.com"
}