locals {
  region_supernets = {
    for i, region in var.regions : region => cidrsubnet(var.vpc_supernet_cidr, var.region_supernet_newbits, i)
  }
  vpc_config = {
    for region, supernet in local.region_supernets : region => {
      vpc_subnet_cidr = cidrsubnet(supernet, var.primary_subnet_newbits, 0)
      secondary_ranges = {
        for name, layout in var.subnet_layout :
        name => cidrsubnet(supernet, layout.newbits, layout.netnum)
      }
    }
  }

  subnet_types = {
    "main" = {
      purpose      = null
      role         = null
      name_prefix  = ""
      ip_range_key = "vpc_subnet_cidr"
    },
    "rmproxy" = {
      purpose      = "REGIONAL_MANAGED_PROXY"
      role         = "ACTIVE"
      name_prefix  = "rmp-"
      ip_range_key = "rmproxy"
    },
    "glproxy" = {
      purpose      = "GLOBAL_MANAGED_PROXY"
      role         = "ACTIVE"
      name_prefix  = "glp-"
      ip_range_key = "glproxy"
    },
    "psc" = {
      purpose      = "PRIVATE_SERVICE_CONNECT"
      role         = "ACTIVE"
      name_prefix  = "psc-"
      ip_range_key = "psc"
    },
    "pnat" = {
      purpose      = "PRIVATE_NAT"
      role         = "ACTIVE"
      name_prefix  = "pnat-"
      ip_range_key = "pnat"
    }
  }

  all_subnets_flat = flatten([
    for region, region_config in local.vpc_config : [
      for subnet_key, subnet_config in local.subnet_types : {
        key                      = subnet_key == "main" ? region : "${subnet_config.name_prefix}${region}"
        name                     = subnet_key == "main" ? region : "${subnet_config.name_prefix}${region}"
        ip_cidr_range            = subnet_key == "main" ? region_config.vpc_subnet_cidr : region_config.secondary_ranges[subnet_config.ip_range_key]
        region                   = region
        purpose                  = subnet_config.purpose
        role                     = subnet_config.role
        private_ip_google_access = contains(["GLOBAL_MANAGED_PROXY", "REGIONAL_MANAGED_PROXY"], subnet_config.purpose == null ? "" : subnet_config.purpose) ? false : true
        log_config = {
          aggregation_interval = var.logs_config.subnet.interval
          flow_sampling        = var.logs_config.subnet.samples
          metadata             = var.logs_config.subnet.metadata
        }
        secondary_ip_range = subnet_key == "main" ? [
          {
            range_name    = "pods"
            ip_cidr_range = region_config.secondary_ranges.pods
          },
          {
            range_name    = "services"
            ip_cidr_range = region_config.secondary_ranges.services
          }
        ] : []
      }
    ]
  ])

  all_subnets = {
    for subnet in local.all_subnets_flat : subnet.key => subnet
  }
}


resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.alias
  auto_create_subnetworks = false
  mtu                     = var.network_mtu
  routing_mode            = "GLOBAL"
}


resource "google_compute_global_address" "peering" {
  name          = "peering-reserved"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  network       = google_compute_network.vpc.id
  project       = var.project_id
  address       = var.peer_allocation
  prefix_length = 20
}


resource "google_service_networking_connection" "private_service_access" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.peering.name]
}


resource "google_compute_subnetwork" "all" {
  for_each = local.all_subnets

  name                     = each.value.name
  ip_cidr_range            = each.value.ip_cidr_range
  region                   = each.value.region
  project                  = var.project_id
  network                  = google_compute_network.vpc.id
  private_ip_google_access = each.value.private_ip_google_access
  purpose                  = each.value.purpose
  role                     = each.value.role

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_range
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  dynamic "log_config" {
    for_each = contains(["GLOBAL_MANAGED_PROXY", "REGIONAL_MANAGED_PROXY"], coalesce(each.value.purpose, "default")) ? [] : [1]
    content {
      aggregation_interval = each.value.log_config.aggregation_interval
      flow_sampling        = each.value.log_config.flow_sampling
      metadata             = each.value.log_config.metadata
    }
  }
}


resource "google_compute_firewall" "rules" {
  for_each = var.firewall_config
  name     = each.key
  network  = google_compute_network.vpc.id
  project  = var.project_id

  dynamic "allow" {
    for_each = toset(each.value.protocol)
    content {
      protocol = allow.value
      ports    = each.value.ports
    }
  }

  log_config {
    metadata = each.value.logs
  }

  priority      = each.value.priority
  target_tags   = each.value.tags
  source_ranges = each.value.source
}


resource "google_compute_address" "nat_ips" {
  for_each = local.vpc_config
  name     = "natip-${each.key}"
  region   = each.key
  project  = var.project_id
}

resource "google_compute_router" "router" {
  for_each = local.vpc_config
  name     = "router-${each.key}"
  region   = each.key
  project  = var.project_id
  network  = google_compute_network.vpc.id
  bgp {
    asn = var.router_asn
  }
}

resource "google_compute_router_nat" "nat" {
  for_each                            = local.vpc_config
  name                                = "nat-${each.key}"
  router                              = google_compute_router.router[each.key].name
  region                              = each.key
  project                             = var.project_id
  nat_ip_allocate_option              = "MANUAL_ONLY"
  nat_ips                             = [google_compute_address.nat_ips[each.key].self_link]
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  enable_endpoint_independent_mapping = false
  enable_dynamic_port_allocation      = true

  log_config {
    enable = var.logs_config.router.enable
    filter = var.logs_config.router.filter
  }
}


resource "google_dns_managed_zone" "private_dns_zone" {
  project    = var.project_id
  name       = var.alias
  dns_name   = "${var.alias}.internal."
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.vpc.id
    }
  }
}