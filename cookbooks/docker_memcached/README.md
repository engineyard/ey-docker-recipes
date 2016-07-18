# Docker Memcached

This recipe runs a memcached container on a utility instance and listens on port 11211 of that instance. It also generates a config file memcached_docker.yml on your application instances that your app can use to connect to memcached.

## How to use this recipe

1. Set the `utility_name` attribute on `docker_memcached/attributes/default.rb`. This is the name of the utility instance where the container will run.

      ```ruby
      default[:docker_memcached] = {
        :utility_name => "docker"
      }

      ```

2. Install docker on the utility instance. If you use a `utility_name` other than "docker" then modify the `docker_custom` recipe to include the utility name.

3. Read `memcached_docker.yml` from your app. This recipe generates `memcached_docker.yml` on all app instances. You can modify the template if needed.

      Here is a sample code for Rails.

      ```ruby
      memcached_config = YAML.load_file(Rails.root.join("config", "memcached_util.yml"))

      {
          "production" => {
              "servers" => [
                  [0] "ip-10-109-190-114.ec2.internal:11211"
              ]
          }
      }
      ```

      If you're using [dalli] as your memcached client,

      ```ruby
      config.cache_store = :dalli_store, memcached_config["production"]["servers"].first,
        { :namespace => NAME_OF_RAILS_APP, :expires_in => 1.day, :compress => true }
      ```

## Docker image

The Docker image used is the official memcached image available on Docker Hub. You can check the latest version available at https://hub.docker.com/r/_/memcached/.

[dalli]: https://github.com/petergoldstein/dalli
