is_util_instance = node["instance_role"] == "util" && node["name"] == "docker"

if is_util_instance
  include_recipe "docker_custom::install"
end
