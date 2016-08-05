is_jenkins_instance = node['dna']['instance_role'] == 'util' && node['dna']['name'] == node['docker_jenkins']['utility_name']

if is_jenkins_instance
  include_recipe 'docker_jenkins::setup_container'
end

if ['solo', 'app_master', 'app'].include?(node['dna']['instance_role'])
  include_recipe 'docker_jenkins::setup_nginx'
end 
