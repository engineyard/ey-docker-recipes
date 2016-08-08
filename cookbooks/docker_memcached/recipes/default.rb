is_docker_memcached_instance = node['dna']['instance_role'] == "util" && node['dna']['name'] == node['docker_memcached']['utility_name']

if is_docker_memcached_instance
  docker_image "memcached" do
    tag "1.4"
    action :pull
  end

  docker_container "my-memcache" do
    repo "memcached"
    tag "1.4"
    port "11211:11211"
    restart_policy "always"
    action :run
  end
end

if ['solo', 'app', 'app_master', 'util'].include?(node['dna']['instance_role'])
  instances = node['dna']['engineyard']['environment']['instances']
  docker_instance = instances.find{|i| i['name'] == node['docker_memcached']['utility_name']}

  if docker_instance.nil?
    raise "Docker instance named '#{node['docker_memcached']['utility_name']}' does not exist. Please fix the docker_memcached recipe."
  end

  node['dna']['engineyard']['environment']['apps'].each do |app|
    directory "/data/#{app['name']}/shared/config" do
      recursive true
      owner node['owner_name']
      group node['owner_name']
      mode 0755
    end

    template "/data/#{app['name']}/shared/config/memcached_docker.yml" do
      owner node['owner_name']
      group node['owner_name']
      mode 0644
      source "memcached_docker.yml.erb"
      variables({
        'environment' => node['dna']['environment']['framework_env'],
        'hostname' => docker_instance['private_hostname']
      })
    end
  end
end
