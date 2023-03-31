---
all:
  children:
    k8s:
      children:
        kube_masters:
          hosts:
            %{ for server in jsondecode(master_servers) }
            ${server.name}:
              ansible_host: ${server.ipv4_address}
            %{ endfor }
        kube_workers:
          hosts:
            %{ for server in jsondecode(worker_servers) }
            ${server.name}:
              ansible_host: ${server.ipv4_address}
            %{ endfor }
        proxy:
          hosts:
            %{ for server in jsondecode(proxy_servers) }
            ${server.name}:
              ansible_host: ${server.ipv4_address}
            %{ endfor }