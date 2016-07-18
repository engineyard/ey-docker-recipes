install_docker = node.dna["instance_role"] == "util" && ["docker"].include?(node.dna["name"])

if install_docker
  include_recipe "docker_custom::install"
end

#include_recipe "docker_memcached"
