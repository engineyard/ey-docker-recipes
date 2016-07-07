is_util_instance = node['instance_role'] == 'util' && node['name'] == 'docker'

docker_installation_tarball 'default' do
  source 'https://test.docker.com/builds/Linux/x86_64/docker-1.12.0-rc2.tgz'
  checksum '6df54c3360f713370aa59b758c45185b9a62889899f1f6185a08497ffd57a39b'
  version '1.12.0-rc2'
end

directory "/data/docker/graph" do
  action :create
  recursive true
  owner "root"
  group "root"
  mode 0755
end

docker_service_manager_monit "default" do
  graph "/data/docker/graph"
  storage_driver "overlay2"
end

["/data/youtrack/lib", "/data/youtrack/local/logs", "/data/youtrack/local/conf", "/data/youtrack/local/data", "/data/youtrack/local/backups"].each do |name|
  directory name do
    action :create
    recursive true
    owner 2000
    group 2000
    mode 0755
  end
end

docker_image "docker-youtrack" do
  repo "dzwicker/docker-youtrack"
  action :pull
end

docker_container 'docker-youtrack' do
  repo 'dzwicker/docker-youtrack'
  port '8081:8080'
  volumes ['/data/youtrack/lib:/var/lib/youtrack', '/data/youtrack/local/logs:/usr/local/youtrack/logs', '/data/youtrack/local/conf:/usr/local/youtrack/conf', '/data/youtrack/local/data:/usr/local/youtrack/data', '/data/youtrack/local/backups:/usr/local/youtrack/backups']
  restart_policy 'always'
  action :run
  kill_after 10
end

docker_image 'busybox' do
  action :pull
end

docker_container 'echo-server' do
  repo 'busybox'
  port '1234:1234'
  command "nc -ll -p 1234 -e /bin/cat"
  restart_policy 'always'
  action :run
end

docker_container 'hello-world' do
  command '/hello'
  action :create
end
