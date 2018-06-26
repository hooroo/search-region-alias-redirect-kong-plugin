local _M = {}

function locationParam(queryParamsTable)
    return queryParamsTable.location
end

function isNotNumberic(value)
    return string.match(value, '^[0-9]+$') == nil
end

function _M.execute(conf)
    local location = locationParam(ngx.req.get_uri_args())

-- if no location param??? fail gracefully
    if isNotNumberic(location) then
        ngx.log(ngx.DEBUG, "Setting upstream host to: " .. conf.search_legacy_host)
        ngx.ctx.balancer_address.host = conf.search_legacy_host
        ngx.log(ngx.DEBUG, "Setting upstream path to: " .. conf.search_legacy_path)
        ngx.var.upstream_uri = conf.search_legacy_path
    end
end

return _M

