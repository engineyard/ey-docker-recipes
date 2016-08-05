service 'nginx' do
  supports restart: true, reload: true, status: true
  action :nothing
end

instances = node['dna']['engineyard']['environment']['instances']
docker_instance = instances.find{|i| i['name'] == node['docker_youtrack']['utility_name']}
if docker_instance && (['app_master', 'app', 'solo'].include? node['dna']['instance_role'])
  template '/etc/nginx/servers/youtrack.conf' do
    owner 'deploy'
    group 'deploy'
    mode 0644
    source 'youtrack.conf.erb'
    notifies :reload, 'service[nginx]'
    variables ({
      server_name: node['docker_youtrack']['server_name'],
      docker_youtrack_hostname: docker_instance['public_hostname']
    })
  end
end
