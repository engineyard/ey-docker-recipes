service 'nginx' do
  supports restart: true, reload: true, status: true
  action :nothing
end

docker_youtrack_instance = node.dna['utility_instances'].select{|i| i['name'].eql?('docker_youtrack')}.first
if docker_youtrack_instance
  docker_youtrack_hostname = docker_youtrack_instance['hostname']

  template '/etc/nginx/servers/youtrack.conf' do
    owner 'deploy'
    group 'deploy'
    mode 0644
    source 'youtrack.conf.erb'
    notifies :reload, 'service[nginx]'
    variables ({
      server_name: 'youtrack.mydomain.com',
      docker_youtrack_hostname: docker_youtrack_hostname
    })
  end
end
