is_todo_rails_instance = node[:dna][:instance_role] == "util" && node[:dna][:name] == "docker"

if is_todo_rails_instance
  include_recipe "docker_todo_rails::database_yml"
  
  docker_image "crigor/todo" do
    tag "latest"
    action :pull
  end

  docker_container "todo" do
    repo "crigor/todo"
    tag "latest"
    port "3000:3000"
    volume ["/data/docker_apps/todo_rails/config/database.yml:/usr/src/app/config/database.yml"]
    restart_policy "always"
    action :run
  end  
end

if ['solo', 'app_master', 'app'].include?(node[:dna][:instance_role])
service 'nginx' do
  supports restart: true, reload: true, status: true
  action :nothing
end

instances = node[:dna][:engineyard][:environment][:instances]
docker_instance = instances.find{|i| i[:name] == node[:docker_todo_rails][:utility_name]}
if docker_instance.nil?
  raise "Docker instance named '#{node[:docker_todo_rails][:utility_name]}' does not exist. Please fix the docker_todo_rails recipe."
end

if docker_instance && (['app_master', 'app', 'solo'].include? node[:dna][:instance_role])
  template '/etc/nginx/servers/docker_todo_rails.conf' do
    owner 'deploy'
    group 'deploy'
    mode 0644
    source 'docker_todo_rails.conf.erb'
    notifies :reload, 'service[nginx]'
    variables ({
      server_name: node[:docker_todo_rails][:domain],
      docker_todo_rails_hostname: docker_instance[:public_hostname]
    })
  end
end
end 
