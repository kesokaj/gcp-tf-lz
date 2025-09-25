output "vpc" {
  value = google_compute_network.vpc.name
}

output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "subnet" {
  value = [
    for s in values(google_compute_subnetwork.all) : s.name
    if s.purpose == null
  ]
}

output "rmproxy" {
  value = [
    for s in values(google_compute_subnetwork.all) : s.name
    if s.purpose == "REGIONAL_MANAGED_PROXY"
  ]
}

output "glproxy" {
  value = [
    for s in values(google_compute_subnetwork.all) : s.name
    if s.purpose == "GLOBAL_MANAGED_PROXY"
  ]
}