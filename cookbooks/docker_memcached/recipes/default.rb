is_docker_memcached_instance = node.dna[:instance_role] == "util" && node.dna[:name] == node[:docker_memcached][:utility_name]

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
