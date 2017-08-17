is_docker_redis_instance = node['dna']['instance_role'] == "util" && node['dna']['name'] == node['docker_redis']['utility_name']

if is_docker_redis_instance
  docker_image "redis" do
    tag "4.0"
    action :pull
  end

  docker_container "my-redis" do
    repo "redis"
    tag "4.0"
    port "6379:6379"
    restart_policy "always"
    action :run
  end
end

if ['solo', 'app', 'app_master', 'util'].include?(node['dna']['instance_role'])
  instances = node['dna']['engineyard']['environment']['instances']
  docker_instance = instances.find { |i| i['name'] == node['docker_redis']['utility_name'] }

  if docker_instance.nil?
    raise "Docker instance named '#{node['docker_redis']['utility_name']}' does not exist. Please fix the docker_redis recipe."
  end

  node['dna']['engineyard']['environment']['apps'].each do |app|
    directory "/data/#{app['name']}/shared/config" do
      recursive true
      owner node['owner_name']
      group node['owner_name']
      mode 0755
    end

    template "/data/#{app['name']}/shared/config/redis_docker.yml" do
      owner node['owner_name']
      group node['owner_name']
      mode 0644
      source "redis_docker.yml.erb"
      variables({
        'environment' => node['dna']['environment']['framework_env'],
        'hostname' => docker_instance['private_hostname']
      })
    end
  end
end
