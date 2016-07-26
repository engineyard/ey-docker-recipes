image = "crigor/todo3"
branch = "july"
command = "git --git-dir=/data/docker_apps/docker_todo_rails/repo/.git log -n1 --format='%h'"

git "/data/docker_apps/docker_todo_rails/repo" do
  repository "git@github.com:crigor/todo.git"
  revision branch
  action :sync
  ssh_wrapper "/data/rackapp/shared/config/rackapp-ssh-wrapper"
end

docker_image image do
  tag branch
  action :pull 
  only_if { false }
  # check registry
end

build_tag_lambda = lambda{command = "git --git-dir=/data/docker_apps/docker_todo_rails/repo/.git log -n1 --format='%h'"; latest_git_commit =  Mixlib::ShellOut.new(command).run_command.stdout.strip; "july-#{latest_git_commit}"}

build_tag_proc = proc{command = "git --git-dir=/data/docker_apps/docker_todo_rails/repo/.git log -n1 --format='%h'"; latest_git_commit =  Mixlib::ShellOut.new(command).run_command.stdout.strip; "#{branch}-#{latest_git_commit}"}

docker_image image do
#latest_git_commit =  Mixlib::ShellOut.new(command).run_command.stdout.strip
#Chef::Log.info "commit: #{latest_git_commit.inspect}"
#build_tag = "july-#{latest_git_commit}"

  #tag build_tag
  #tag lazy{command = "git --git-dir=/data/docker_apps/docker_todo_rails/repo/.git log -n1 --format='%h'"; latest_git_commit =  Mixlib::ShellOut.new(command).run_command.stdout.strip; "july-#{latest_git_commit}"}
  tag lazy(&build_tag_proc)
  action :build
  source "/data/docker_apps/docker_todo_rails/repo"
  read_timeout 600
  only_if {
    begin
      Docker::Image.get("#{image}:#{build_tag_proc.call}")
      false
    rescue
      true
    end
  }
end

docker_tag "tag image" do
#latest_git_commit =  Mixlib::ShellOut.new(command).run_command.stdout.strip
#Chef::Log.info "commit: #{latest_git_commit.inspect}"
#build_tag = "july-#{latest_git_commit}"
  target_repo  image
  #target_tag build_tag
  #target_tag lazy{command = "git --git-dir=/data/docker_apps/docker_todo_rails/repo/.git log -n1 --format='%h'"; latest_git_commit =  Mixlib::ShellOut.new(command).run_command.stdout.strip; "july-#{latest_git_commit}"}
  target_tag lazy(&build_tag_proc)
  to_repo image
  to_tag branch
  action :tag
  force true
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
