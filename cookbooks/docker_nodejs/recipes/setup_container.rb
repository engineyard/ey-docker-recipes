# FIXME move to its own docker_redis cookbook
docker_image 'redis' do
  tag '3.2.1'
  action :pull
end

docker_container 'redis' do
  repo 'redis'
  network_mode 'host'
  tag '3.2.1'
  restart_policy 'always'
  action :run
end

# Original recipe from
# https://github.com/engineyard/ey-cookbooks-stable-v5-DELETEME/blob/master/cookbooks/sequelizejs/recipes/default.rb.
# Check this upstream source for updates.

directory '/data/docker_apps/docker_nodejs/config' do
  owner node['owner_name']
  group node['owner_name']
  recursive true
end

template '/data/docker_apps/docker_nodejs/config/config.json' do
  owner node['owner_name']
  group node['owner_name']
  mode 0644
  source 'config.json.erb'
  variables({
    :dialect => node['docker_nodejs']['database']['dialect'],
    :database => node['docker_nodejs']['database']['name'],
    :username => node['dna']['engineyard']['environment']['ssh_username'],
    :password => node['dna']['engineyard']['environment']['ssh_password'],
    :host => node['dna']['db_host']
  })
end


source_image = docker_image node['docker_nodejs']['image'] do
  tag node['docker_nodejs']['tag']
  action :pull
end

docker_container 'chat' do
  repo source_image.repo
  network_mode 'host'
  volumes %w(/data/docker_apps/docker_nodejs/config/config.json:/usr/src/app/config/config.json)
  tag source_image.tag
  restart_policy 'always'
  action :run
end  

