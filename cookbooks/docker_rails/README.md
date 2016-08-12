# docker_rails

Deployment of Engine Yard's sample Rails application [1] in Docker. This will
deploy the application in an instance called `docker`.

[1] https://github.com/engineyard/todo

## Usage

Add the following dependency to in `cookbooks/ey-custom/metadata.rb`:

```
depends 'docker_rails'
```

Add the following line to your `cookbooks/ey-custom/recipes/after-main.rb`:

```
include_recipe 'docker_rails::default'
```

## Building a Docker image

You can build your image from your local machine or from an Engine Yard Cloud instance.

On the root of your rails application, create `Dockerfile`

```
FROM engineyard/rails

WORKDIR /usr/src/app
ENV RAILS_ENV production

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --without development test

COPY . /usr/src/app
RUN bundle exec rake DATABASE_URL=postgresql:does_not_exist assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
```

Build the image and push it to Docker Hub.

```
docker build -t your_username/app_name .
docker push your_username/app_name 
```

## Running your app

To run your app, change the `image` and `tag` on `cookbooks/docker_rails/attributes/default.rb`.

```
  'image' => 'your_username/app_name',
  'tag' => 'latest'
```

Create `/data/docker_apps/docker_rails/config/secrets.yml` manually or by using `ey scp`. You only have to do this once.

`/data/docker_apps/docker_rails/config/database.yml` is created by the `docker_rails` recipe for you. It uses the database running on your environment. If you want to use a different database, comment out `include_recipe "docker_rails::database_yml"` on `cookbooks/docker_rails/recipes/default.rb`.

## Uploading your recipes

After making the changes above, upload your recipes to your environment and click Apply on the Engine Yard Cloud UI.

```
ey recipes upload -e environment_name
```

## Debugging your container

If your rails app doesn't start after chef finishes, run the container and use `bash` as the command. Once you're inside the container, start rails manually. Make sure you have both `secrets.yml` and `database.yml` on `/data/docker_apps/docker_rails/config/`.

```
# ssh to the utility instance
docker run -it -v /data/docker_apps/docker_rails/config/database.yml:/usr/src/app/config/database.yml -v /data/docker_apps/docker_rails/config/secrets.yml:/usr/src/app/config/secrets.yml your_username/app_name bash

# inside the container
rails server -b 0.0.0.0
```

## LICENSE

Copyright 2016 Engine Yard, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

