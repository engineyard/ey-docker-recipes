# Docker Redis

This recipe runs a redis container on a utility instance and listens on port 6379 of that instance. It also generates a config file redis_docker.yml on your application instances that your app can use to connect to redis.

## How to use this recipe

1. Set the `utility_name` attribute on `docker_redis/attributes/default.rb`. This is the name of the utility instance where the container will run.

      ```ruby
      default[:docker_redis] = {
        :utility_name => "docker"
      }

      ```

2. Install docker on the utility instance. If you use a `utility_name` other than "docker" then modify the `docker_custom` recipe to include the utility name.

3. Read `redis_docker.yml` from your app. This recipe generates `redis_docker.yml` on all app instances. You can modify the template if needed.

      Here is a sample code for Rails.

      ```ruby
      redis_config = YAML.load_file(Rails.root.join("config", "redis_util.yml"))

      {
          "production" => {
              "servers" => [
                  [0] "ip-10-109-190-114.ec2.internal:6379"
              ]
          }
      }
      ```

## Docker image

The Docker image used is the official redis image available on Docker Hub. You can check the latest version available at https://hub.docker.com/r/_/redis/.

