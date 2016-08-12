directory "/data/docker_apps/docker_rails/config" do
  action :create
  recursive true
  owner node['owner_name']
  group node['owner_name']
  mode 0755
end

db_type = case node['dna']['engineyard']['environment']['db_stack_name']
          when /postgres/
            "postgresql"
          when /mysql/
            "mysql2"
          end

template "/data/docker_apps/docker_rails/config/database.yml" do
  owner node['owner_name']
  group node['owner_name']
  mode 0600
  source "database.yml.erb"
  variables({
    'environment' => "production",
    'dbuser' => node['dna']['users'].first['username'],
    'dbpass' => node['dna']['users'].first['password'],
    'dbname' => "docker_rails",
    'dbhost' => node['dna']['db_host'],
    'dbtype' => db_type
  })
end
