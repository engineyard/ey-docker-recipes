nginx = resources('service[nginx]') || service('nginx')
nginx.supports restart: true, reload: true, status: true
nginx.action :nothing

instances = node['dna']['engineyard']['environment']['instances']
docker_instance = instances.find{|i| i[:name] == node['docker_jenkins']['utility_name']}
if docker_instance.nil?
  raise "Docker instance named '#{node['docker_todo_rails']['utility_name']}' "\
    'does not exist. Please fix the docker_todo_rails recipe.'
end

if docker_instance && (['app_master', 'app', 'solo'].include? node['dna']['instance_role'])
  template '/etc/nginx/servers/jenkins.conf' do
    owner 'deploy'
    group 'deploy'
    mode 0644
    source 'jenkins.conf.erb'
    notifies :reload, 'service[nginx]'
    variables ({
      server_name: node['docker_jenkins']['domain'],
      jenkins_hostname: docker_instance['public_hostname']
    })
  end
end

