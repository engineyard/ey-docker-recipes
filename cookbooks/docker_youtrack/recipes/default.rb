is_youtrack_instance = (node['dna']['instance_role'] == 'util') && (node['dna']['name'] == node['docker_youtrack']['utility_name'])
if is_youtrack_instance
  include_recipe 'docker_youtrack::setup_container'
end

if ['solo', 'app_master', 'app'].include?(node['dna']['instance_role'].to_s)
  include_recipe 'docker_youtrack::setup_nginx'
end
