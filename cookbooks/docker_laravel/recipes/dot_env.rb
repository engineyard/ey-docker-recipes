directory "/data/docker_apps/docker_laravel/config" do
  action :create
  recursive true
  owner node['owner_name']
  group node['owner_name']
  mode 0755
end

db_connection = case node['dna']['engineyard']['environment']['db_stack_name']
          when /postgres/
            "pgsql"
          when /mysql/
            "mysql"
          end

template "/data/docker_apps/docker_laravel/config/.env" do
  owner node['owner_name']
  group node['owner_name']
  mode 0644
  source "env.erb"
  variables({
    'app_env' => node['dna']['environment']['framework_env'],
    'db_host' => node['dna']['db_host'],
    'db_database' => "quickstart",
    'db_username' => node['dna']['users'].first['username'],
    'db_password' => node['dna']['users'].first['password'],
    'db_connection' => db_connection
  })
end
