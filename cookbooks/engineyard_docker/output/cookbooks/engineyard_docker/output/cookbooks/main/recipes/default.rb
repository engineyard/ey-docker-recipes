# FIXME: Submitted as a pull request in [1]. Wait for it to be merged and
# released then update as follows:
# docker_installation_tarball 'default' do
#   only_if { node['instance_role'] == 'util' && node['name'] == 'docker' }
# end
#
# [1] https://github.com/chef-cookbooks/docker/pull/712
tarball = remote_file "#{Chef::Config[:file_cache_path]}/docker-1.11.1.tgz" do
  source 'https://get.docker.com/builds/Linux/x86_64/docker-1.11.1.tgz'
  checksum '893e3c6e89c0cd2c5f1e51ea41bc2dd97f5e791fcfa3cee28445df277836339d'
  notifies :run, 'execute[extract tarball]', :immediately
  only_if { node['instance_role'] == 'util' && node['name'] == 'docker' }
end

execute 'extract tarball' do
  command "tar xzf #{tarball.path} --strip-components=1 -C /usr/bin"
  action :nothing
  %w(/usr/bin/docker /usr/bin/docker-containerd /usr/bin/docker-containerd-ctr
     /usr/bin/docker-runc /usr/bin/docker-contianerd-shim).each do |file|
    creates file
  end
end

docker_service_manager 'default' do
  only_if { node['instance_role'] == 'util' && node['name'] == 'docker' }
end
