[master]
${master_nodes_ip}

[node]
${worker_nodes_ip}

[k3s_cluster:children]
master
node
