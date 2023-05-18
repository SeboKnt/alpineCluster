---
all:
  children:
    k3s:
      children:
        master:
          hosts:
            %{ for server in jsondecode(master_servers) }
            ${server.name}:
              ansible_host: ${server.ipv4_address}
            %{ endfor }
        worker:
          hosts:
            %{ for server in jsondecode(worker_servers) }
            ${server.name}:
              ansible_host: ${server.ipv4_address}
            %{ endfor }