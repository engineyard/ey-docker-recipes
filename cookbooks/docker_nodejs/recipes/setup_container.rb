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

docker_image 'aespinosa/engineyard-chat' do
  tag 'latest'
  action :pull
end

docker_container 'chat' do
  repo 'aespinosa/engineyard-chat'
  network_mode 'host'
  tag 'latest'
  restart_policy 'always'
  action :run
end  

