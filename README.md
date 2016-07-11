# Docker on stable-v5 

## Installation

1. Boot an environment using the stable-v5 stack.
2. Download the engineyard gem on your local machine.
3. Clone this repository on your local machine.
4. Upload the custom chef recipes from your local machine.

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
ey recipes upload --apply -e environment_name
```

## Running containers

### Using the command line

Now that docker is installed, you can run containers.

```
docker run hello-world
```

While you can run containers from the command line, we recommend that you use chef.

### Using chef

You can run containers from any of your recipes. A good starting point is `cookbooks/customer_docker/recipes/default.rb`.

You need to pull the image before running a container. We will use `docker_image` and `docker_container`.

```
docker_image "memcached" do
  tag "1.4.27"
  action :pull
end

docker_container "my-memcache" do
  repo "memcached"
  port "11211:11211"
  restart_policy "always"
  action :run
end
```

We're forwarding port 11211 on the instance to 11211 on the my-memcache container. We can check that memcached is listening on 11211 by looking at the stats

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

## Data volumes

When a container is deleted, all data it wrote inside the container would be deleted as well. To save data outside of the container, we need to use a data volume. This volume maps a directory on the instance to a directory inside the container.

The official redis image writes data on the /data directory inside the container. We can create /data/redis on the instance and map this to the container

```
docker_image "redis" do
  tag "3.2.1"
  action :pull
end

docker_container "my-redis" do
  repo "redis"
  command "redis-server --appendonly yes"
  port "6379:6379"
  volumes ["/data/redis:/data"]
  restart_policy "always"
  action :run
end
```

When the my-redis container is deleted in the future, the redis data would remain on /data/redis on the instance. Engine Yard Cloud takes AWS snapshots of /data on the instance. These snapshots serve as the backups of your redis data. You're also free to back up /data/redis to an external location.

When you create the my-redis container again, either on the same instance or a new instance, redis would have your previous data.
