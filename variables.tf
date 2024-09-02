locals {
  default_tags = {
    Billing : "team-${local.team}",
    BillingTag : "team-${local.team}",
    Team : local.team,
    env : local.env
  }

//gobal variable must be changed each time
  env = "dev" //sandbox,dev,stg,release,uat,prod
  team = "infra" //frontend,backend,infra,app

//vpc variable
  vpc_name="test-dev-clustervpc-v1"
  vpc_instance_tenancy="default"
  vpc_cidr="10.35.0.0/18"
  vpc_private_subnets     = ["10.35.0.0/20","10.35.16.0/20"]
  vpc_public_subnets      = ["10.35.32.0/20","10.35.48.0/20"]
  vpc_azs                 = ["ap-southeast-1a","ap-southeast-1b"]
}

variable "is_multiple_ngw" {
  description = "Multi NAT gateway or single NAT gateway."
  type        = bool
  default     = false
}

variable "is_multiple_private_routetable" {
  description = "Multi route table or single route table."
  type        = bool
  default     = true
}