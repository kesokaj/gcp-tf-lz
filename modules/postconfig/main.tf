resource "null_resource" "set_project" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "gcloud config set project ${var.project_id} && gcloud config set billing/quota_project ${var.project_id} && gcloud auth application-default set-quota-project ${var.project_id}"
  }
}