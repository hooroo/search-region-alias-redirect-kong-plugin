local _M = {}

function isNumeric(value)
    return string.match(value, '^[0-9]+$') ~= nil
end

function isValid (value)
    return value ~= nil and value ~= ''
end

function _M.execute(conf)
    local location = ngx.req.get_uri_args().location

    if isValid(location) and (not isNumeric(location)) then
        ngx.log(ngx.DEBUG, "Setting upstream host to: " .. conf.search_legacy_host)
        ngx.ctx.balancer_address.host = conf.search_legacy_host
        ngx.log(ngx.DEBUG, "Setting upstream path to: " .. conf.search_legacy_path)
        ngx.var.upstream_uri = conf.search_legacy_path
    end
end

return _M

