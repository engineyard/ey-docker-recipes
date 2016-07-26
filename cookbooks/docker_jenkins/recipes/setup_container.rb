docker_image 'jenkins' do
  tag '2.7.1'
  action :pull
end

directory '/data/jenkins' do
  owner 1000
  group 1000
end

docker_container 'jenkins' do
  repo 'jenkins'
  port %w(8082:8080 5000:5000)
  tag '2.7.1'
  volume ['/data/jenkins:/var/jenkins_home']
  restart_policy 'always'
  action :run
end  
