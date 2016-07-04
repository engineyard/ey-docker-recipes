is_util_instance = node['instance_role'] == 'util' && node['name'] == 'docker'

docker_installation_tarball 'default' do
  source 'https://test.docker.com/builds/Linux/x86_64/docker-1.12.0-rc2.tgz'
  checksum '6df54c3360f713370aa59b758c45185b9a62889899f1f6185a08497ffd57a39b'
  version '1.12.0-rc2'
  only_if { is_util_instance }
end

docker_service_manager 'default' do
  only_if { is_util_instance }
end
