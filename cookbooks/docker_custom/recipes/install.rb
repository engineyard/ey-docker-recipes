docker_installation_tarball "default" do
  source "https://test.docker.com/builds/Linux/x86_64/docker-1.12.0-rc2.tgz"
  checksum "6df54c3360f713370aa59b758c45185b9a62889899f1f6185a08497ffd57a39b"
  version "1.12.0-rc2"
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
  storage_driver "overlay"
end

