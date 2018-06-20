local _M = {}

function locationParam(queryParamsTable)

end

function _M.isNumbersOnly(value)
    return string.match(value, '^[0-9]+$') ~= nil
end


function _M.execute(conf)
    location = locationParam(ngx.req.get_uri_args)

    if isNumbersOnly(location) then
        ngx.var.upstream_uri = conf.search_legacy_uri
    else
        ngx.var.upstream_uri = conf.search_uri
    end
end

return _M