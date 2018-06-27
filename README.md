# Search Region Alias redirect Kong plugin

A Kong API gateway plugin to forward search requests to an alternate endpoint depending on whether the location 
parameter is an Id or alias.

When query params: 

- `/availability?location=12344` => search request sent to Ava
- `/availability?location=DPS` => search request sent to BILI 


## To develop and test against a local Kong

### Install Lua

Install Lua

### Run the test 

`$ make dev test`

### Install Kong and Kong DB 

Taken from: https://docs.konghq.com/install/docker/

1. Install Kong DB: 
   
   `$ docker-compose up kong-migration`

1. Start the Kong app with your plugin installed. 

   `$ docker-compose up kong`
    
1. Check the Admin console

   `http://localhost:8001/` 


### Setup the API

From: https://docs.konghq.com/0.11.x/getting-started/adding-your-api/

Note, that a fake API created was created using: `https://www.mockapi.io/` to be used as the upstream service. 

1. Create the API

   `$ curl -i -X POST \
  --url http://localhost:8001/apis/ \
  --data 'name=search-api' \
  --data 'hosts=example.com' \
  --data 'upstream_url=http://5b306993db0f5e001465b65c.mockapi.io/availability/ava'`

1. Enable the plugin on the API
   
   `$ curl -i -X POST \
  --url http://localhost:8001/apis/search-api/plugins/ \
  --data 'name=search-region-alias-redirect' \
  --data 'config.search_legacy_host=5b306993db0f5e001465b65c.mockapi.io' \
  --data 'config.search_legacy_path=/availability/legacy'`


### Make a request to Kong  

`$ curl -i -X GET   --url http://localhost:8000?location=23132131   --header 'Host: example.com'`

`$ curl -i -X GET   --url http://localhost:8000?location=ABCDEF   --header 'Host: example.com'`


## Deploying your plugin

Ask Scott to help

## Useful references

- https://hub.docker.com/_/kong/
- https://docs.konghq.com/0.11.x/getting-started/adding-your-api/
- https://docs.konghq.com/0.13.x/getting-started/configuring-a-service/
- https://docs.konghq.com/0.13.x/getting-started/enabling-plugins/
- https://github.com/Kong/kong/tree/master/kong/plugins/request-transformer
- https://github.com/nvmlabs/kong-dynamic-upstream/blob/master/spec/access_spec.lua
- http://olivinelabs.com/busted/#overview