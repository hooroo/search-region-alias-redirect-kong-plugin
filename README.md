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
   
   `$ docker run -d --rm --name kong-database --network=kong-net -p 5432:5432 -e "POSTGRES_USER=kong" -e "POSTGRES_DB=kong"               postgres:9.6`
1. Run the DB migrations:

   `$ docker run --rm \
    --network=kong-net \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_PG_HOST=kong-database" \
    kong:latest kong migrations up`
    
1. Start the Kong app with your plugin installed. 

   `$ docker run -d --rm --name kong --network=kong-net -v $(pwd)/src:/tmp/plugins/kong/plugins/search-region-alias-redirect -e "KONG_DATABASE=postgres"     -e "KONG_PG_HOST=kong-database"   -e "KONG_PROXY_ACCESS_LOG=/dev/stdout"     -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" -e "KONG_PROXY_ERROR_LOG=/dev/stderr"     -e "KONG_ADMIN_ERROR_LOG=/dev/stderr"     -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" -e "KONG_LOG_LEVEL=debug" -e "KONG_LUA_PACKAGE_PATH=/tmp/plugins/?.lua;;" -e "KONG_CUSTOM_PLUGINS=search-region-alias-redirect" -p 8000:8000     -p 8443:8443     -p 8001:8001     -p 8444:8444 kong:latest`

    - -v flag mounts your plugin code so Kong can access it
    - KONG_CUSTOM_PLUGINS and KONG_LUA_PACKAGE_PATH install the plugin
    
1. Check the Admin console

   `http://localhost:8001/` 
   
1. Follow logs
 
   `$ docker logs -f kong`
   

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



### Reload Kong

After making changes to the plugin code or on changing Kong config(via env vars)

`$ docker exec -it kong kong reload` 

