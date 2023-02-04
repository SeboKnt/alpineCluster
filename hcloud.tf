# Set the variable value in *.tfvars file
variable "hcloud_token" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = "${var.hcloud_token}"
}

data "hcloud_primary_ip" "ip-ns1" {
  ip_address = "168.119.172.132"
}

data "hcloud_primary_ip" "ip-ns2" {
  ip_address = "49.12.236.130"
}

data "hcloud_primary_ip" "ip-zwerggans" {
  ip_address = "95.217.156.114"
}

data "hcloud_primary_ip" "ip-spatz" {
  ip_address = "116.202.8.94"
}

data "hcloud_primary_ip" "ip-schwalbe" {
  ip_address = "23.88.97.13"
}

data "hcloud_image" "mint" {
  with_selector = "origin"
}

resource "hcloud_server" "node-zwerggans" {
  name        = "zwerggans"
  image       = data.hcloud_image.mint.id
  server_type = "cx21"
  location    = "hel1"
  public_net {
    ipv4_enabled = true
    ipv4 = data.hcloud_primary_ip.ip-zwerggans.id
    ipv6_enabled = true
  }
}

resource "hcloud_server" "node-spatz" {
  name        = "spatz"
  image       = data.hcloud_image.mint.id
  server_type = "cx21"
  location    = "fsn1"
  public_net {
    ipv4_enabled = true
    ipv4 = data.hcloud_primary_ip.ip-spatz.id
    ipv6_enabled = true
  }
}

resource "hcloud_server" "node-schwalbe" {
  name        = "schwalbe"
  image       = data.hcloud_image.mint.id
  server_type = "cx21"
  location    = "nbg1"
  public_net {
    ipv4_enabled = true
    ipv4 = data.hcloud_primary_ip.ip-schwalbe.id
    ipv6_enabled = true
  }
}