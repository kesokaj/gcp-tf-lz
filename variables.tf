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
    "constraints/compute.requireOsLogin",  # Enforces OS Login on Compute Engine VMs for improved security
    "constraints/compute.requireShieldedVm",  # Requires the use of Shielded VMs for enhanced VM security
    "constraints/compute.trustedImageProjects",  # Defines a list of trusted projects for VM images
    "constraints/compute.vmExternalIpAccess",  # Controls external IP access for Compute Engine VMs
    "constraints/compute.disableInternetNetworkEndpointGroup",  # Disables the creation of internet-facing Network Endpoint Groups
    "constraints/iam.disableServiceAccountKeyCreation",  # Prevents the creation of service account keys
    "constraints/iam.disableServiceAccountCreation",  # Prevents the creation of service accounts
    "constraints/compute.disableNestedVirtualization",  # Disables nested virtualization on Compute Engine VMs
    "constraints/cloudfunctions.requireVPCConnector",  # Requires Cloud Functions to use VPC connectors for network access
    "constraints/iam.allowedPolicyMemberDomains",  # Restricts the allowed domains for IAM policy members
    "constraints/storage.uniformBucketLevelAccess",  # Enforces uniform bucket-level access for Cloud Storage buckets
    "constraints/sql.restrictAuthorizedNetworks",  # Restricts authorized networks for Cloud SQL instances
    "constraints/compute.disableSerialPortLogging",  # Disables serial port logging for Compute Engine VMs
    "constraints/compute.disableSerialPortAccess",  # Disables serial port access for Compute Engine VMs
    "constraints/compute.vmCanIpForward",  # Controls IP forwarding for Compute Engine VMs
    "constraints/compute.restrictProtocolForwardingCreationForTypes"  # Restricts the creation of protocol forwarding rules for specific VM types
  ]
}

variable "service_list" {
  type = list(any)
  default = [
    "orgpolicy.googleapis.com",  # Organization Policy Service - For managing organization-wide policies and constraints
    "dns.googleapis.com",        # Cloud DNS - For managing DNS records and zones
    "compute.googleapis.com",     # Compute Engine - For creating and managing virtual machines
    "networkmanagement.googleapis.com",  # Network Management - For network monitoring, troubleshooting, and optimization
    "servicenetworking.googleapis.com",  # Service Networking - For connecting, securing, and observing services
    "servicedirectory.googleapis.com",  # Service Directory - For service discovery and management
    "networkconnectivity.googleapis.com",  # Network Connectivity - For managing network connections across your infrastructure
    #"cloudaicompanion.googleapis.com",  # Cloud AI Companion - (Commented out) For AI-powered assistance and automation
    "cloudquotas.googleapis.com", # Enable quota metrics in the console - For viewing and managing resource quotas
    "logging.googleapis.com",    # Cloud Logging - For collecting, storing, and analyzing log data
    "monitoring.googleapis.com",  # Cloud Monitoring - For monitoring the performance and availability of your applications and infrastructure
    "clouderrorreporting.googleapis.com",  # Cloud Error Reporting - For tracking and managing application errors
    "cloudtrace.googleapis.com",  # Cloud Trace - For distributed tracing and debugging of applications
    "opsconfigmonitoring.googleapis.com",  # Ops Config Monitoring - For monitoring the configuration of your systems
    "servicehealth.googleapis.com",  # Service Health - For getting information about Google Cloud service health
    "cloudlatencytest.googleapis.com",  # Cloud Latency Test - For measuring network latency to Google Cloud regions
    "timeseriesinsights.googleapis.com",  # Time Series Insights - For storing, analyzing, and querying time series data
    "checks.googleapis.com",      # Cloud Monitoring Checks - For creating and managing uptime checks
    "cloudidentity.googleapis.com",  # Cloud Identity - For managing user identities and access control
    "containersecurity.googleapis.com",  # Container Security - For securing your containerized applications
    "certificatemanager.googleapis.com",  # Certificate Manager - For provisioning and managing SSL/TLS certificates
    "artifactregistry.googleapis.com",  # Artifact Registry - For storing and managing build artifacts and dependencies
    "cloudbuild.googleapis.com",   # Cloud Build - For building and deploying applications
    "containerregistry.googleapis.com",  # Container Registry - For storing and managing Docker images
    "osconfig.googleapis.com",     # OS Config - For managing and configuring operating systems
    "bigqueryconnection.googleapis.com",  # BigQuery Connection - For connecting to BigQuery from external applications
    "biglake.googleapis.com",     # BigLake - For managing and querying data lakes
    "networkservices.googleapis.com",  # Network Services - For managing network services like load balancing and traffic management
    "edgenetwork.googleapis.com",  # Edge Network - For deploying and managing applications at the edge of the network
    "networktopology.googleapis.com",  # Network Topology - For visualizing and understanding your network topology
    "vpcaccess.googleapis.com",    # VPC Access - For connecting to your VPC network from on-premises or other cloud environments
    "tagmanager.googleapis.com",   # Tag Manager - For managing tags and resources
    "pubsub.googleapis.com",      # Cloud Pub/Sub - For asynchronous messaging and data ingestion
    "pubsublite.googleapis.com",  # Cloud Pub/Sub Lite - For cost-effective, high-throughput messaging
    "cloudresourcemanager.googleapis.com",  # Cloud Resource Manager - For managing your cloud resources, including projects, folders, and organizations
    "firewallinsights.googleapis.com",  # Firewall Insights - For analyzing firewall logs and traffic
    "datastudio.googleapis.com",  # Data Studio - For creating interactive dashboards and reports
    "cloud.googleapis.com",       # Google Cloud APIs -  A general API for accessing various Google Cloud services
    "storage-component.googleapis.com",
    "storage.googleapis.com",
    "storageinsights.googleapis.com"
  ]
}

