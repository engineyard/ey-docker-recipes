
credential_file = '/home/deploy/.docker/config.json'

registries = node['docker_custom']['registries']

ruby_block 'load docker registry credentials' do
  block do
    require 'json'
    require 'base64'

    registries.each do |endpoint|
      registry = resources("docker_registry[#{endpoint}]")
      credentials = JSON.parse(File.read credential_file)['auths']

      unless credentials[registry.serveraddress]
        raise "Cannot find credentials for registry #{registry.serveraddress}"
      end

      base64 = Base64.decode64 credentials[registry.serveraddress]['auth']
      username, password = base64.split ':'

      registry.email credentials[registry.serveraddress]['auth']['email']
      registry.username  username
      registry.password password
    end
  end
  only_if { File.exists? credential_file }
end

registries.each do |endpoint|
  docker_registry endpoint do
    only_if { File.exists? credential_file }
  end
end
