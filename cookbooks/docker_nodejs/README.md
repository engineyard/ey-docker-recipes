# docker_nodejs

Deployment of Engineyard's sample Chat application [1] in Docker. This will
deploy the application in an instance called `docker`.

[1] https://github.com/engineyard/chat

## Usage

Add the following dependency to in `cookbooks/ey-custom/metadata.rb`:

```
depends 'docker_nodejs'
```

Add the following line to your `cookbooks/ey-custom/recipes/after-main.rb`:

```
include_recipe `docker_nodejs::default`
```

## Building a Docker image

You can build your image from a local Docker host or from an Engine Yard Cloud
instance with Docker installed.

On the root of your NodeJS application, create the following `Dockerfile`:

```
FROM node:4.4.5

ENV NODE_ENV production

ADD . /usr/src/app

WORKDIR /usr/src/app
RUN npm install

CMD node /usr/src/app/app.js
```

This assumes that your NodeJS application's main entry point is through
`app.js`. Adjust the `Dockerfile` above to accomodate your application's needs.


After preparing the `Dockerfile`, you can now build the image and push it to a 
registry like Docker Hub:


```
docker build -t your_username/app_name .
docker push your_username/app_name 
```

## Running the application

To run your application, update the following attributes in
`cookbooks/docker_nodejs/attributes/default.rb` to point to the image you built
earlier:

```
default['docker_nodejs']['image'] = 'your_username/app_name'
default['docker_nodejs']['tag'] = 'latest'

```

You can retrieve the credential information about the database master in the
environment by parsing the `/usr/src/app/config/config.json` file inside the container.

## Debugging the container

If the NodeJS application doesn't boot after Chef converges, you can spin up the
container manually and enter it interactively with the following command:

```
# ssh into the utility instance
inside-util> docker run -it -v /data/docker_nodejs/shared/config/config.json:/usr/src/app/config/config.json your_username/app_name bash
inside-container> node app.js
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

