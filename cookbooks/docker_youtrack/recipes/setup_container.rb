['/data/youtrack/lib', '/data/youtrack/local/logs', '/data/youtrack/local/conf', '/data/youtrack/local/data', '/data/youtrack/local/backups'].each do |name|
  directory name do
    action :create
    recursive true
    owner 2000
    group 2000
    mode 0755
  end
end

docker_image 'docker-youtrack' do
  repo 'dzwicker/docker-youtrack'
  action :pull
end

docker_container 'docker-youtrack' do
  repo 'dzwicker/docker-youtrack'
  port '9090:8080'
  volumes ['/data/youtrack/lib:/var/lib/youtrack', '/data/youtrack/local/logs:/usr/local/youtrack/logs', '/data/youtrack/local/conf:/usr/local/youtrack/conf', '/data/youtrack/local/data:/usr/local/youtrack/data', '/data/youtrack/local/backups:/usr/local/youtrack/backups']
  restart_policy 'always'
  action :run
  kill_after 10
end
