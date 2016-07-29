is_nodejs_instance = node['dna']['instance_role'] == 'util' && node['dna']['name'] == 'docker' #node['docker_nodejs']['utility_name']

include_recipe 'docker_nodejs::setup_container' if is_nodejs_instance

if ['solo', 'app_master', 'app'].include?(node['dna']['instance_role'])
  include_recipe 'docker_nodejs::setup_nginx'
end
