is_youtrack_instance = (node.dna['instance_role'].eql? 'util') && (node.dna['name'].eql? 'docker_youtrack')
if is_youtrack_instance
  include_recipe 'customer_docker::install'
  include_recipe 'docker_youtrack::setup_container'
end

is_app_instance = ['solo', 'app_master', 'app'].include?(node.dna['instance_role'])
if is_app_instance
  include_recipe 'docker_youtrack::setup_nginx'
end
