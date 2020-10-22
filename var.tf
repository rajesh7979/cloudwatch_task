variable "Name" {
  type    = string
  default = "s3-logging"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "current_version_expiration_days" {
  default     = "90"
  description = "How many days to store logs before they will be deleted"
}

variable "current_glacier_transition_days" {
  default     = "60"
  description = "How many days to store logs before they will be transitioned to Glacier"
}

variable "noncurrent_version_expiration_days" {
  default     = "90"
  description = "How many days to store logs before they will be deleted"
}


variable "noncurrent_glacier_transition_days" {
  default     = "60"
  description = "How many days to store logs before they will be transitioned to Glacier"
}

variable "enable_logging" {
  default     = "true"
  description = "Specifies whether to enable logging for the trail."
}

variable "include_global_service_events" {
  default     = "true"
  description = "Specifies whether the trail is publishing events from global services such as IAM."
}

variable "is_multi_region_trail" {
  default     = "true"
  description = "Specifies whether the trail is created in the current region or in all regions."
}

variable "enable_log_file_validation" {
  default     = "true"
  description = "Specifies whether log file integrity validation is enabled."
}

variable "s3_key_prefix" {
  type        = string
  default     = "CloudTrailLogs"
  description = "Specifies the S3 key prefix that precedes the name of the bucket you have designated for log file delivery."
}

variable "profile" {
  type    = string
  default = "cloudwatch-test"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "vpc_name" {
  type    = string
  default = ""
}

variable "subnet_public_A_name" {
  type    = string
  default = ""
}

variable "subnet_public_B_name" {
  type    = string
  default = ""
}


variable "subnet_private_A_name" {
  type    = string
  default = ""
}

variable "subnet_private_B_name" {
  type    = string
  default = ""
}

variable "subnet_private_AA_name" {
  type    = string
  default = ""
}

variable "subnet_private_BB_name" {
  type    = string
  default = ""
}

variable "igw_name" {
  type    = string
  default = ""
}

variable "security_group_cluster_name" {
  type    = string
  default = ""
}

variable "security_group_alb_name" {
  type    = string
  default = ""
}

variable "cluster_key" {
  type    = string
  default = ""
}

variable "cluster_target_group" {
  type    = string
  default = ""
}

variable "alb_name" {
  type    = string
  default = ""
}

variable "route_public_name" {
  type    = string
  default = ""
}

variable "route_privateA_name" {
  type    = string
  default = ""
}


variable "route_privateB_name" {
  type    = string
  default = ""
}


variable "natAeip_name" {
  type    = string
  default = ""
}

variable "natBeip_name" {
  type    = string
  default = ""
}

variable "natA_privateA_name" {
  type    = string
  default = ""
}

variable "natB_privateB_name" {
  type    = string
  default = ""
}

variable "vpn_client_name" {
  type    = string
  default = ""
}

variable "security_group_vpn_name" {
  type    = string
  default = ""
}

variable "role_arn_resource" {
  type    = string
  default = ""
}

## bp2-mdso-20.10.01-20 AMI image
#variable "amis" {
#type = map
#default = {
#"us-east-1"  = "ami-05cf1a38813860f0a",
#"us-west-2"  = "ami-0166f3246e10620bd",
#"ap-south-1" = "ami-0bd178605e7f7c189"
#}
#}

# bp2-nfvo-20.10.01-20 AMI image
variable "amis" {
  type = map
  default = {
    "us-east-1"  = "ami-06f0a4a848b51d668",
    "us-west-2"  = "ami-0166f3246e10620bd",
    "ap-south-1" = "ami-02e615725ffbae9d8"
  }
}

# bp2-inventory-20.10.0-SNAPSHOT-4
#==> Builds finished. The artifacts of successful builds are:
#--> bp2-ami: AMIs were created:
#ap-south-1: ami-03eef8490841f8fbe
#us-east-1: ami-01ca98283c13e669b
#us-west-2: ami-05485285650a8664e



variable "fqdn" {
  type    = string
  default = ""
}

variable "route53-dns" {
  type    = string
  default = ""
}


# NOTE:  values = dev, uat, test, prod, mysetup ... keep it simple no capitals (alphanumeric and hyphens only)  
variable "clusterName" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "172.20.0.0/21"
}

variable "private_subnetA" {
  type    = string
  default = "172.20.1.0/25"
}

variable "private_subnetAA" {
  type    = string
  default = "172.20.1.128/25"
}

variable "private_subnetB" {
  type    = string
  default = "172.20.2.0/25"
}

variable "private_subnetBB" {
  type    = string
  default = "172.20.2.128/25"
}

variable "public_subnetA" {
  type    = string
  default = "172.20.3.0/25"
}

variable "public_subnetB" {
  type    = string
  default = "172.20.3.128/25"
}

variable "site_network_mask" {
  type    = string
  default = "/25"
}

variable "vpn_tunnel" {
  type    = string
  default = "172.28.0.0/21"
}

variable "instance_type" {
  type    = string
  default = "m2.micro"
}

variable "volume_size" {
  type    = string
  default = "350"
}

variable "load_balancer_type" {
  type    = string
  default = "application"
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "provider_alias" {
  type    = string
  default = ""
}

variable "deploy_nfvo_config" {
  description = "If set to true, deploy custom config script"
  type        = bool
  default     = false
}


locals {
  subnet_public_A_name        = "${var.subnet_public_A_name != "" ? var.subnet_public_A_name : "${var.clusterName}_publicA"}"
  subnet_public_B_name        = "${var.subnet_public_B_name != "" ? var.subnet_public_B_name : "${var.clusterName}_publicB"}"
  subnet_private_A_name       = "${var.subnet_private_A_name != "" ? var.subnet_private_A_name : "${var.clusterName}_privateA"}"
  subnet_private_B_name       = "${var.subnet_private_B_name != "" ? var.subnet_private_B_name : "${var.clusterName}_privateB"}"
  subnet_private_AA_name      = "${var.subnet_private_AA_name != "" ? var.subnet_private_AA_name : "${var.clusterName}_privateAA"}"
  subnet_private_BB_name      = "${var.subnet_private_BB_name != "" ? var.subnet_private_BB_name : "${var.clusterName}_privateBB"}"
  igw_name                    = "${var.igw_name != "" ? var.igw_name : "${var.clusterName}_saas_internet_gateway"}"
  route_public_name           = "${var.route_public_name != "" ? var.route_public_name : "${var.clusterName}_saas-public"}"
  route_privateA_name         = "${var.route_privateA_name != "" ? var.route_privateA_name : "${var.clusterName}_saas-privateA"}"
  route_privateB_name         = "${var.route_privateB_name != "" ? var.route_privateB_name : "${var.clusterName}_saas-privateB"}"
  natAeip_name                = "${var.natAeip_name != "" ? var.natAeip_name : "${var.clusterName}_natAeip"}"
  natBeip_name                = "${var.natBeip_name != "" ? var.natBeip_name : "${var.clusterName}_natBeip"}"
  natA_privateA_name          = "${var.natA_privateA_name != "" ? var.natA_privateA_name : "${var.clusterName}_natA_privateA"}"
  natB_privateB_name          = "${var.natB_privateB_name != "" ? var.natB_privateB_name : "${var.clusterName}_natA_privateB"}"
  cluster_key                 = "${var.cluster_key != "" ? var.cluster_key : "${var.clusterName}-key"}"
  security_group_cluster_name = "${var.security_group_cluster_name != "" ? var.security_group_cluster_name : "${var.clusterName}_Cluster_SG"}"
  security_group_vpn_name     = "${var.security_group_vpn_name != "" ? var.security_group_vpn_name : "${var.clusterName}_VPN_SG"}"
  vpc_name                    = "${var.vpc_name != "" ? var.vpc_name : "${var.clusterName}_VPC"}"
  cluster_target_group        = "${var.cluster_target_group != "" ? var.cluster_target_group : "${var.clusterName}-TG"}"
  security_group_alb_name     = "${var.security_group_alb_name != "" ? var.security_group_alb_name : "${var.clusterName}_ALB_SG"}"
  alb_name                    = "${var.alb_name != "" ? var.alb_name : "${var.clusterName}-privateA-ALB"}"
  vpn_client_name             = "${var.vpn_client_name != "" ? var.vpn_client_name : "${var.clusterName}_VPN"}"
  provider_alias              = "${var.provider_alias != "" ? var.provider_alias : "aws.default"}"
}


