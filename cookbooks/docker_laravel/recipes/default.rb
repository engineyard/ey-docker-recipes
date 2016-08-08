is_laravel_instance = node['dna']['instance_role'] == "util" && node['dna']['name'] == node['docker_laravel']['utility_name']

if is_laravel_instance
  include_recipe "docker_laravel::dot_env"
  
  docker_image "crigor/quickstart_laravel" do
    tag "latest"
    action :pull
  end

  docker_container "quickstart" do
    repo "crigor/quickstart_laravel"
    tag "latest"
    port "7000:8000"
    volume ["/data/docker_apps/docker_laravel/config/.env:/usr/src/app/.env"]
    restart_policy "always"
    action :run
  end  
end

if ['solo', 'app_master', 'app'].include?(node['dna']['instance_role'])
service 'nginx' do
  supports restart: true, reload: true, status: true
  action :nothing
end

instances = node['dna']['engineyard']['environment']['instances']
docker_instance = instances.find{|i| i['name'] == node['docker_laravel']['utility_name']}
if docker_instance.nil?
  raise "Docker instance named '#{node['docker_todo_rails']['utility_name']}' does not exist. Please fix the docker_docker_laravel recipe."
end

if docker_instance && (['app_master', 'app', 'solo'].include? node['dna']['instance_role'])
  template '/etc/nginx/servers/docker_laravel.conf' do
    owner 'deploy'
    group 'deploy'
    mode 0644
    source 'docker_laravel.conf.erb'
    notifies :reload, 'service[nginx]'
    variables ({
      server_name: node['docker_laravel']['domain'],
      docker_laravel_hostname: docker_instance['public_hostname']
    })
  end
end
end 
