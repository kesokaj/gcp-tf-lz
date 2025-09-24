
module "project" {
  source          = "./modules/project"
  billing_id      = var.billing_id
  org_id          = var.org_id
  org_policy_list = var.org_policy_list
  service_list    = var.service_list
}

resource "null_resource" "delay_after_project" {
  depends_on = [module.project]

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

module "network" {
  depends_on        = [null_resource.delay_after_project]
  source            = "./modules/network"
  alias             = module.project.alias
  alias_id          = module.project.alias_id
  project_id        = module.project.project_id
  regions           = var.regions
  vpc_supernet_cidr = var.vpc_supernet_cidr
  firewall_config   = var.firewall_config
  peer_allocation   = var.peer_allocation
  logs_config       = var.logs_config
  router_asn        = var.router_asn
  network_mtu       = var.network_mtu
}

resource "null_resource" "delay_after_network" {
  depends_on = [module.network]

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

module "postconfig" {
  depends_on = [null_resource.delay_after_network]
  source     = "./modules/postconfig"
  project_id = module.project.project_id
}

