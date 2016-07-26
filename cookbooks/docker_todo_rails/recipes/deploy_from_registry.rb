image = "crigor/todo3"
branch = "latest"

docker_image image do
  tag branch
  action :pull 
  # only_if { false }
  # check registry
end
  
docker_container "todo" do
  repo image
  tag branch 
  port "3000:3000"
  volume ["/data/docker_apps/docker_todo_rails/config/database.yml:/usr/src/app/config/database.yml"]
  restart_policy "always"
  action :run
end  

execute "redeploy #{image}" do
  notifies :redeploy, "docker_container[todo]", :immediately
  action :run
  only_if {Docker::Container.get("todo").info["Image"] != Docker::Image.get("#{image}:#{branch}").id}
  command "true"
end

