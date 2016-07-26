# docker_jenkins

Launches Jenkins in a Docker container inside an Engineyard v5 environment.
Jenkins will be installed in an Utility instance called `docker`.

## Usage

Add the following dependency to in `cookbooks/ey-custom/metadata.rb`:

```
depends 'docker_jenkins'
```

Add the following line to your `cookbooks/ey-custom/recipes/after-main.rb`:

```
include_recipe `docker_jenkins::default`
```

## Customization

This customization is useful when you have multiple Utility instances that are
built as Docker hosts.

If you want to setup Jenkins in a Utility instance with a different name like 
`docker_jenkins`, update the following in
`cookbooks/docker_jenkins/attributes/default.rba`:

```
default['docker_jenkins'].tap do |jenkins|
  jenkins['utility_name'] = 'docker_jenkins'
  jenkins['domain'] = 'jenkins.example.com'
end
```

Make sure to setup Docker in the `docker_jenkins` instance. Update
`cookbooks/docker_custom/attributes/default.rb`:


```
default['docker_custom']['docker_instances'] = %w(docker docker_jenkins)
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
