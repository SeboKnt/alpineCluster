hcloud_token = "igG0zJPPWKBK5AWin6CZS9fbsjSmdXPIb5okCpDo88HoHzFyaAo2B2tSLzgvgw2I"

# Token deprecated

# cluster name will be added as label to all the server that get created
cluster = "k8s-ap23-eu-1"

server = {
  n1-k8s-ap23-eu-1 = {
    type   = "cx21-sandy"
    region = "nbg1"
    role   = "master"   # lables the server
  },
  n2-k8s-ap23-eu-1 = {
    type   = "cx21-sandy"
    region = "fsn1"
    role   = "master"
  },
  n3-k8s-ap23-eu-1 = {
    type   = "cpx11"
    region = "hel1"
    role   = "master"
  }
}

##loadbalancer = {
##  lb1 = {
##    type      = "lb11"
##    region    = "nbg1"
##    nodes     = "cluster=k8s-ap23-eu-1" # can also be e.g. worker for ingress 
##    protocol  = "tcp"                   
##    incomming = 6443                    #  this should be then set to 443/80 or similar
##    outgoing  = 6443
##  }
##}