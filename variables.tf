variable "billing_id" {
  type = string
}

variable "org_id" {
  type = string
}

variable "firewall_config" {
  type = map(any)
  description = "Firewall rules in VPC"
  default = {
    "allow-rdp-tcp": {
      "procotol" : "tcp",
      "ports" : ["3389"],
      "tags": ["rdp"],
      "source" : ["0.0.0.0/0"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "100"
    },
    "allow-ssh-tcp": {
      "procotol" : "tcp",
      "ports" : ["22"],
      "tags": ["ssh"],
      "source" : ["0.0.0.0/0"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "100"
    },
    "allow-healthcheck-tcp": {
      "procotol" : "tcp",
      "ports": ["0-65535"],
      "tags": [],
      "source" : ["130.211.0.0/22","35.191.0.0/16","209.85.152.0/22","209.85.204.0/22"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "500"
    },
    "allow-healthcheck-udp": {
      "procotol" : "udp",
      "ports": ["0-65535"],
      "tags": [],
      "source" : ["130.211.0.0/22","35.191.0.0/16","209.85.152.0/22","209.85.204.0/22"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "500"
    },    
    "allow-iap-tcp": {
      "procotol" : "tcp",
      "tags": [],      
      "ports": ["0-65535"]
      "source" : ["35.235.240.0/20"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "500"
    },
    "allow-iap-udp": {
      "procotol" : "udp",
      "tags": [],      
      "ports": ["0-65535"]
      "source" : ["35.235.240.0/20"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "500"
    },    
    "allow-icmp": {
      "procotol" : "icmp",
      "ports": [],
      "tags": [],      
      "source" : ["0.0.0.0/0"],
      "logs" : "EXCLUDE_ALL_METADATA",
      "priority" : "65535"
    },
    "allow-internal-tcp": {
      "procotol" : "tcp",
      "ports": ["0-65535"],
      "tags": [],      
      "source" : ["10.0.0.0/8"],
      "logs" : "EXCLUDE_ALL_METADATA",
      "priority" : "65535"
    },
    "allow-internal-udp": {
      "procotol" : "udp",
      "ports": ["0-65535"],
      "tags": [],      
      "source" : ["10.0.0.0/8"],
      "logs" : "EXCLUDE_ALL_METADATA",
      "priority" : "65535"
    },    
    "allow-http": {
      "procotol" : "tcp",
      "ports": ["80"],
      "tags": ["http"],
      "source" : ["0.0.0.0/0"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "100"
    },
    "allow-https": {
      "procotol" : "tcp",
      "ports": ["443"],
      "tags": ["https"],
      "source" : ["0.0.0.0/0"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "100"
    },
    "allow-custom": {
      "procotol" : "tcp",
      "ports": ["8080","3000"],
      "tags": ["custom"],
      "source" : ["0.0.0.0/0"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "100"
    },
    "allow-kube-api": {
      "procotol" : "tcp",
      "ports": ["6443"],
      "tags": ["kube-api"],
      "source" : ["0.0.0.0/0"],
      "logs" : "INCLUDE_ALL_METADATA",
      "priority" : "100"
    }        
  }
}

variable "vpc_config" {
  type        = map(any)
  description = "Regions for VPC Subnets to be created"
  default = {
    "us-central1" : {
      "vpc_subnet_cidr" : "10.1.0.0/22"
      "secondary_ranges" :{
        "gke-master" : "10.1.4.0/24",        
        "proxy" : "10.1.5.0/24",
        "psc" : "10.1.6.0/24",
        "services" : "10.1.16.0/20",
        "pods" : "10.1.128.0/17",              
      }
    },
    "europe-west1" : {
      "vpc_subnet_cidr" : "10.2.0.0/22"
      "secondary_ranges" :{
        "gke-master" : "10.2.4.0/24",        
        "proxy" : "10.2.5.0/24",
        "psc" : "10.2.6.0/24",
        "services" : "10.2.16.0/20",
        "pods" : "10.2.128.0/17", 
      }      
    },
    "europe-north1" : {
      "vpc_subnet_cidr" : "10.3.0.0/22"
      "secondary_ranges" :{
        "gke-master" : "10.3.4.0/24",        
        "proxy" : "10.3.5.0/24",
        "psc" : "10.3.6.0/24",
        "services" : "10.3.16.0/20",
        "pods" : "10.3.128.0/17", 
      }      
    }
    "asia-east1" : {
      "vpc_subnet_cidr" : "10.4.0.0/22"
      "secondary_ranges" :{
        "gke-master" : "10.4.4.0/24",        
        "proxy" : "10.4.5.0/24",
        "psc" : "10.4.6.0/24",
        "services" : "10.4.16.0/20",
        "pods" : "10.4.128.0/17", 
      }      
    },
    "europe-west4" : {
      "vpc_subnet_cidr" : "10.5.0.0/22"
      "secondary_ranges" :{
        "gke-master" : "10.5.4.0/24",        
        "proxy" : "10.5.5.0/24",
        "psc" : "10.5.6.0/24",
        "services" : "10.5.16.0/20",
        "pods" : "10.5.128.0/17", 
      }      
    }        
  }
}

variable "logs_config" {
  type = map(any)
  description = "Logging from subnets (flowlogs)"
  default = {
    "subnet" : {
      "interval" : "INTERVAL_15_MIN",
      "samples" : "0.25",
      "metadata" : "INCLUDE_ALL_METADATA"
    },
    "router" : {
      "enable" : "true",
      "filter" : "ALL" #ERRORS
    }
  }
}

variable "peer_allocation" {
  type = string
  description = "Peering network for different services a /20 will be used"
  default = "10.100.0.0"
}

variable "org_policy_list" {
  type = list(any)
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
  type = list(any)
  default = [
    "orgpolicy.googleapis.com",
    "dns.googleapis.com",
    "compute.googleapis.com",
    "networkmanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "servicedirectory.googleapis.com",
    "networkconnectivity.googleapis.com",
    #"cloudaicompanion.googleapis.com",
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
    "firewallinsights.googleapis.com"
  ]
}

