# docker_laravel

Deployment of the quickstart-basic laravel app [1] in Docker. This will
deploy the application in an instance called `docker`.

[1] https://github.com/laravel/quickstart-basic

## Usage

Add the following dependency to in `cookbooks/ey-custom/metadata.rb`:

```
depends 'docker_laravel'
```

Add the following line to your `cookbooks/ey-custom/recipes/after-main.rb`:

```
include_recipe 'docker_laravel::default'
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

