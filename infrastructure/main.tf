# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = "${var.hcloud_token}"
}

# copies the local ssh key into the server while creating them
# can also be done by the cloud init or play_common for multiple keys 
resource "hcloud_ssh_key" "default" {
  name       = "key"
  public_key = file("~/.ssh/id_rsa.pub")
}

##resource "hcloud_placement_group" "master" {
##  name = "${var.cluster}-master"
##  type = "spread"
##  labels = {
##    type = "master"
##  }
##}
##
##resource "hcloud_placement_group" "worker" {
##  name = "${var.cluster}-worker"
##  type = "spread"
##  labels = {
##    type = "worker"
##  }
##}
##
##resource "hcloud_placement_group" "proxy" {
##  name = "${var.cluster}-proxy"
##  type = "spread"
##  labels = {
##    type = "proxy"
##  }
##}

# creates the server that are listed in terraform.ftvars
resource "hcloud_server" "server" {
    for_each = var.server

    name        = each.key
    image       = "ubuntu-22.04"
    server_type = each.value.type
    location    = each.value.region
    ##placement_group_id = each.value.role == "master" ? hcloud_placement_group.master.id : (each.value.role == "worker" ? hcloud_placement_group.worker.id : hcloud_placement_group.proxy.id)
    ssh_keys    = [hcloud_ssh_key.default.id]
    user_data = file("./cloud-init")  

    labels = {
      cluster = var.cluster 
      type    = each.value.role
    }
}


# creates the loadbalancer that are listed in terraform.ftvars
##resource "hcloud_load_balancer" "load_balancer" {
##  for_each           = var.loadbalancer
##
##  name               = each.key
##  load_balancer_type = each.value.type
##  location           = each.value.region
##}

# assigns server to loadbalancer (server have to be labeled for that)
##resource "hcloud_load_balancer_target" "load_balancer_target" {
##  for_each         = var.loadbalancer
##
##  load_balancer_id = lookup(hcloud_load_balancer.load_balancer, each.key).id
##  type             = "label_selector"
##  label_selector   = each.value.nodes
##}

# configures the services
##resource "hcloud_load_balancer_service" "load_balancer_service" {
##  for_each         = var.loadbalancer
##
##  load_balancer_id = lookup(hcloud_load_balancer.load_balancer, each.key).id
##  protocol         = each.value.protocol
##  listen_port      = each.value.incomming
##  destination_port = each.value.outgoing
##}

# writes the new servers' IP adresses into a seperate file "server_ips.yaml"
# is not needed but it help if want to extend an already existing cluster 
resource "local_file" "server_ips_yaml" {
  filename = "server_ips.yaml"
  content = yamlencode({
    servers = {
      for name, server in hcloud_server.server :
      name => hcloud_server.server[name].ipv4_address
    }
  })
}


# graps all server with specific label

data "hcloud_servers" "master_servers" {
  with_selector = "type=master"
}

data "hcloud_servers" "worker_servers" {
  with_selector = "type=worker"
}

##data "hcloud_servers" "proxy_servers" {
##  with_selector = "type=proxy"
##}

# imports the inventroy template
data "template_file" "ansible_inventory" {
  template = "${file("inventory.yaml.tpl")}"
  vars     = {
    master_servers = jsonencode([
      for s in data.hcloud_servers.master_servers.servers : {
        name = s.name
        ipv4_address = s.ipv4_address
      }
    ])
    worker_servers = jsonencode([
      for s in data.hcloud_servers.worker_servers.servers : {
        name = s.name
        ipv4_address = s.ipv4_address
      }
    ])
    ##proxy_servers = jsonencode([
    ##  for s in data.hcloud_servers.proxy_servers.servers : {
    ##    name = s.name
    ##    ipv4_address = s.ipv4_address
    ##  }
    ##])
  }
}

# fills template with all IPs and names of server that are labeled with master/woker/proxy
resource "local_file" "ansible_inventory" {
  content = data.template_file.ansible_inventory.rendered
  filename = "../inventory.yaml"
}