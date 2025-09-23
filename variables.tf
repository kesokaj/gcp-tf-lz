variable "billing_id" {
  type        = string
  description = "The ID of the billing account to be associated with the project."
}

variable "org_id" {
  type        = string
  description = "The ID of the organization to which the project belongs."
}

variable "regions" {
  description = "A list of GCP regions where the VPC and subnets will be created."
  type        = list(string)
  default     = ["us-central1", "europe-west1", "europe-west2"]
}

variable "firewall_config" {
  type = map(object({
    protocol = list(string)
    ports    = list(string)
    tags     = list(string)
    source   = list(string)
    logs     = string
    priority = string
  }))
  description = "A map of firewall rules to be created in the VPC. The keys are the rule names and the values are the rule configurations."
  default = {
    "allow-rdp-tcp" : {
      "protocol" : ["tcp"],
      "ports" : ["3389"],
      "tags" : ["rdp"],
      "source" : ["0.0.0.0/0"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "100"
    },
    "allow-ssh-tcp" : {
      "protocol" : ["tcp"],
      "ports" : ["22"],
      "tags" : ["ssh"],
      "source" : ["0.0.0.0/0"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "100"
    },
    "allow-healthcheck" : {
      "protocol" : ["tcp", "udp"],
      "ports" : ["0-65535"],
      "tags" : [],
      "source" : ["130.211.0.0/22", "35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "30000"
    },
    "allow-iap" : {
      "protocol" : ["tcp", "udp"],
      "tags" : [],
      "ports" : ["0-65535"],
      "source" : ["35.235.240.0/20"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "30000"
    },
    "allow-icmp" : {
      "protocol" : ["icmp"],
      "ports" : [],
      "tags" : [],
      "source" : ["0.0.0.0/0"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "65534"
    },
    "allow-internal" : {
      "protocol" : ["tcp", "udp"],
      "ports" : ["0-65535"],
      "tags" : [],
      "source" : ["10.0.0.0/8"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "65534"
    },
    "allow-http" : {
      "protocol" : ["tcp"],
      "ports" : ["80"],
      "tags" : ["http"],
      "source" : ["0.0.0.0/0"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "100"
    },
    "allow-https" : {
      "protocol" : ["tcp"],
      "ports" : ["443"],
      "tags" : ["https"],
      "source" : ["0.0.0.0/0"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "100"
    },
    "allow-custom" : {
      "protocol" : ["tcp"],
      "ports" : ["8080", "3000", "2222", "8443"],
      "tags" : ["custom"],
      "source" : ["0.0.0.0/0"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "100"
    }
  }
}



variable "logs_config" {
  type = object({
    subnet = object({
      interval = string
      samples  = number
      metadata = string
    })
    router = object({
      enable = bool
      filter = string
    })
  })
  description = "A map of logging configurations for the VPC. The keys are the log types (e.g., 'subnet', 'router') and the values are the logging configurations."
  default = {
    "subnet" : {
      "interval" : "INTERVAL_15_MIN",
      "samples" : 0.25,
      "metadata" : "INCLUDE_ALL_METADATA"
    },
    "router" : {
      "enable" : true,
      "filter" : "ALL"
    }
  }
}

variable "peer_allocation" {
  type        = string
  description = "The /20 CIDR block to be reserved for peering with other services."
  default     = "10.100.0.0"
}

variable "router_asn" {
  type        = number
  description = "The BGP ASN for the Cloud Router."
  default     = 64512
}

variable "vpc_supernet_cidr" {
  type        = string
  description = "The supernet CIDR block for the VPC. This will be divided into smaller subnets for each region."
  default     = "10.0.0.0/8"
}

variable "org_policy_list" {
  type        = list(string)
  description = "A list of organization policies to be applied to the project."
  default = [
    "constraints/compute.requireOsLogin",
    "constraints/compute.requireShieldedVm",
    "constraints/compute.trustedImageProjects",
    "constraints/compute.vmExternalIpAccess",
    "constraints/compute.disableInternetNetworkEndpointGroup",
    "constraints/iam.disableServiceAccountKeyCreation",
    "constraints/iam.disableServiceAccountCreation",
    "constraints/compute.disableNestedVirtualization",
    "constraints/cloudfunctions.requireVPCConnector",
    "constraints/iam.allowedPolicyMemberDomains",
    "constraints/storage.uniformBucketLevelAccess",
    "constraints/sql.restrictAuthorizedNetworks",
    "constraints/compute.disableSerialPortLogging",
    "constraints/compute.disableSerialPortAccess",
    "constraints/compute.vmCanIpForward",
    "constraints/compute.restrictProtocolForwardingCreationForTypes"
  ]
}

variable "service_list" {
  type        = list(string)
  description = "A list of APIs to be enabled on the project."
  default = [
    "aiplatform.googleapis.com",
    "orgpolicy.googleapis.com",
    "dns.googleapis.com",
    "compute.googleapis.com",
    "networkmanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "servicedirectory.googleapis.com",
    "networkconnectivity.googleapis.com",
    "cloudaicompanion.googleapis.com",
    "cloudquotas.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "clouderrorreporting.googleapis.com",
    "cloudtrace.googleapis.com",
    "opsconfigmonitoring.googleapis.com",
    "servicehealth.googleapis.com",
    "cloudlatencytest.googleapis.com",
    "timeseriesinsights.googleapis.com",
    "checks.googleapis.com",
    "cloudidentity.googleapis.com",
    "containersecurity.googleapis.com",
    "certificatemanager.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "containerregistry.googleapis.com",
    "osconfig.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "biglake.googleapis.com",
    "networkservices.googleapis.com",
    "edgenetwork.googleapis.com",
    "networktopology.googleapis.com",
    "vpcaccess.googleapis.com",
    "tagmanager.googleapis.com",
    "pubsub.googleapis.com",
    "pubsublite.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "firewallinsights.googleapis.com",
    "datastudio.googleapis.com",
    "cloud.googleapis.com",
    "storage-component.googleapis.com",
    "storage.googleapis.com",
    "storageinsights.googleapis.com",
    "networksecurity.googleapis.com",
    "recommender.googleapis.com",
    "cloudasset.googleapis.com",
    "maintenance.googleapis.com",
    "serviceusage.googleapis.com",
    "generativelanguage.googleapis.com",
    "geminicloudassist.googleapis.com",
    "iap.googleapis.com",
    "run.googleapis.com",
    "clouddeploy.googleapis.com",
    "runapps.googleapis.com",
    "container.googleapis.com",
    "gkehub.googleapis.com"
  ]
}

variable "network_mtu" {
  type        = number
  description = "The MTU of the VPC network."
  default     = 8896
}