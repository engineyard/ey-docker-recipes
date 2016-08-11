default['docker_nodejs']['utility_name'] = 'docker'
default['docker_nodejs']['server_name'] = 'nodejs.example.com'

default['docker_nodejs']['database'].tap do |db|
  db['dialect'] = 'postgresql'
  db['name'] = 'docker_nodejs'
end
