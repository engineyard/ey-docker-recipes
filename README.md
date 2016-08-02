# Docker on stable-v5 

## Installation

1. Boot an environment using the stable-v5 stack.
2. Download the engineyard gem on your local machine.
3. Clone this repository on your local machine.
4. Upload the custom chef recipes from your local machine.
5. Click Apply on the environment page on Engine Yard Cloud

### 1. Boot a stable-v5 environment

Boot a utility instance named "docker" on your environment. You can do this on a new environment or add the utility instance on an existing stable-v5 environment.

### 2. Download the engineyard gem

On your local machine, run `gem install engineyard`.

### 3. Clone the docker custom chef recipes

On your local machine, run 

```
git clone https://github.com/engineyard/ey-docker-recipes
cd ey-docker-recipes
```

### 4. Upload the custom chef recipes

On your local machine, run this on the ey-docker-recipes directory

```
ey recipes upload -e environment_name
```

### 5. Click Apply

Go to the environment page on Engine Yard Cloud. Click the Apply button. This will run the main chef recipes and custom chef recipes on a *single* chef run.

## Running containers

### Using the command line

Now that docker is installed, you can run containers.

```
docker run hello-world
```

While you can run containers from the command line, we recommend that you use chef.

### Using chef

You can run containers from any of your recipes. You can start at `cookbooks/docker_custom/recipes/default.rb` when you're just trying out docker.

You need to pull the image before running a container. We will use `docker_image` and `docker_container`.

```ruby
docker_image "memcached" do
  tag "1.4"
  action :pull
end

docker_container "my-memcache" do
  repo "memcached"
  tag "1.4"
  port "11211:11211"
  restart_policy "always"
  action :run
end
```

We're forwarding port 11211 on the instance to 11211 on the `my-memcache` container. We can check that memcached is listening on 11211 by looking at the stats

```
# on the instance
(echo stats ; echo quit ) | nc 127.0.0.1 11211

STAT pid 1
STAT uptime 117
STAT time 1467689573
STAT version 1.4.27
STAT libevent 2.0.21-stable
STAT pointer_size 64
STAT rusage_user 0.033000
STAT rusage_system 0.026000
STAT curr_connections 10
STAT total_connections 13
...
```

## Generating config file

Now that you have memcached running on port 11211 on the utility instance named "docker", your app instances can start using it. You need to generate a yml file which you can name memcached_docker.yml.

While this code can go to `docker_custom`, it's best to use a separate recipe and include it from `ey-custom::after-main`. See [Organizing your recipes](#organizing-your-recipes).

```ruby
if ['solo', 'app', 'app_master', 'util'].include?(node.dna[:instance_role])
  template "/data/#{app[:name]}/shared/config/memcached_docker.yml" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "memcached_docker.yml.erb"
    variables({
      :environment => node.dna[:environment][:framework_env],
      :hostname => docker_instance[:private_hostname]
    })
  end
end
```

This is just a snippet. Check `docker_memcached` for the complete recipe.

## Using data volumes

When a container is deleted, all data it wrote inside the container would be deleted as well. To save data outside of the container, we need to use a data volume. This volume maps a directory on the instance to a directory inside the container.

The official redis image writes data on the /data directory inside the container. We can create /data/redis on the instance and map this to the container

```ruby
docker_image "redis" do
  tag "3.2.1"
  action :pull
end

docker_container "my-redis" do
  repo "redis"
  tag "3.2.1"
  command "redis-server --appendonly yes"
  port "6379:6379"
  volumes ["/data/redis:/data"]
  restart_policy "always"
  action :run
end
```

When the `my-redis` container is deleted in the future, the redis data would remain on /data/redis on the instance. Engine Yard Cloud takes AWS snapshots of /data on the instance. These snapshots serve as the backups of your redis data. You're also free to back up /data/redis to an external location.

When you create the `my-redis` container again, either on the same instance or a new instance, redis would have your previous data.

## Organizing your recipes

This repository has 5 recipes that are required to use docker. You only need to edit `docker_custom` and `ey-custom`.

### docker

This is the docker recipe from Chef Supermarket. Do not edit this recipe.

### compat_resource

This is a dependency of the docker recipe. Do not edit this recipe.

### engineyard_docker

This is a wrapper to the docker recipe that is used for Engine Yard instances. Do not edit this recipe.

### docker_custom

`docker_custom` installs docker on utility instances. By default it uses the utility instance named "docker". If you want to run docker on multiple utility instances, edit `docker_custom/attributes/default.rb`.

```ruby
default[:docker_custom] = {
  :docker_instances => ["docker", "docker2", "docker3", "docker4"]
}
```

### ey-custom

`ey-custom::after-main` runs after all main chef recipes. This makes it a good place to add most of your custom chef recipes.

You need to edit 2 files when adding a recipe.

1. On `ey-custom/recipes/after-main.rb`, add `include_recipe "RECIPE_NAME"`. For example `include_recipe "docker_memcached"`.

2. On `ey-custom/metadata.rb`, add `depends "RECIPE_NAME"`. For example `depends "docker_memcached"`.

If you're creating a new recipe, create `cookbooks/RECIPE_NAME/recipes/default.rb`.
