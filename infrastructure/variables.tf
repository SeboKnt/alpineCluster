# tells terraform what provider and version to use
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 1.3.9"
}

# will look for the in terraform.tfvars or will ask you if not provided
variable "hcloud_token" {}

variable "cluster" {} 


# teaches terraform which attributes are to be requested for the resources

##variable "placement_group_mappings" {
##  type = map(string)
##  default = {
##    master = "master"
##    worker = "worker"
##    proxy  = "proxy"
##  }
##}

variable "server" {
    type = map(object({
        type   = string
        region = string
        role   = string
    }))
}

##variable "loadbalancer" {
##    type = map(object({
##        type      = string
##        region    = string
##        nodes     = string
##        protocol  = string
##        incomming = number
##        outgoing  = number
##    }))
##}