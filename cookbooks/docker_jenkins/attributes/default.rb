default['docker_jenkins'].tap do |jenkins|
  jenkins['utility_name'] = 'docker'
  jenkins['domain'] = 'jenkins.example.com'
end
