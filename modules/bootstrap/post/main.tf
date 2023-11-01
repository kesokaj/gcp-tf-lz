resource "google_compute_project_metadata" "x" {
  metadata = {
    serial-port-enable  = "TRUE"
  }
  project = var.project_id
}

resource "null_resource" "set_project" {
  triggers = {
    always_run = "${timestamp()}"
  }  
  provisioner "local-exec" {
    command = "gcloud config set project ${var.project_id}"
  }
}