module "base" {
  source = "./modules/bootstrap/base"
  billing_id = var.billing_id
  org_id = var.org_id
  org_policy_list = var.org_policy_list
  service_list = var.service_list
}

module "network" {
  depends_on = [ module.base ]  
  source = "./modules/bootstrap/network"
  alias = module.base.alias
  project_id = module.base.project_id
  vpc_config = var.vpc_config
  firewall_config = var.firewall_config
  peer_allocation = var.peer_allocation
  logs_config = var.logs_config
}

module "post" {
  depends_on = [ module.network ]
  source = "./modules/bootstrap/post"
  project_id = module.base.project_id
  alias = module.base.alias
}