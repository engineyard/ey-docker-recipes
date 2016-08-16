
credential_file = '/home/deploy/.docker/config.json'

ruby_block 'load dockerhub credentials' do
  block do
    require 'json'
    require 'base64'

    registry = resources('docker_registry[https://index.docker.io/v1/]')
    credentials = JSON.parse(File.read credential_file)['auths']

    base64 = Base64.decode64 credentials[registry.serveraddress]['auth']
    username, password = base64.split ':'

    registry.email credentials[registry.serveraddress]['auth']['email']
    registry.username  username
    registry.password password
  end
  only_if { File.exists? credential_file }
end

docker_registry 'https://index.docker.io/v1/' do
  only_if { File.exists? credential_file }
end
