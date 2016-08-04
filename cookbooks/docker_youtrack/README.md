# Docker YouTrack

This recipe runs a YouTrack container on a utility instance and listens on port 9090 of that instance.
It also generates an Nginx config file `/etc/nginx/servers/youtrack.conf` on app instances in the environment, so that Nginx will forward requests to the YouTrack container on the utility instance.

## How to use this recipe

1. Set the `utility_name` attribute on `docker_youtrack/attributes/default.rb`. This is the name of the utility instance where the container will run.

      ```ruby
      default[:docker_youtrack] = {
        :utility_name => "docker"
      }

      ```

2. Enable the recipe

  Uncomment or add the line below to https://github.com/engineyard/ey-docker-recipes/blob/master/cookbooks/ey-custom/metadata.rb
  
  ```
  depends "docker_youtrack"
  ``` 
  
  Uncomment or add the line below to https://github.com/engineyard/ey-docker-recipes/blob/master/cookbooks/ey-custom/recipes/after-main.rb
  
  ```
  include_recipe "docker_youtrack"
  ```

## Docker image

The Docker image used is the dzwicker/docker-youtrack image available on Docker Hub. You can check the latest version available at https://hub.docker.com/r/dzwicker/docker-youtrack.
