local _M = {}

local function locationParam(queryParamsTable)

end

local function isNumbersOnly(value)
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

--return _M



function test(scenario, value)
    print(scenario .. ": " .. tostring(isNumbersOnly(value)))
end

test('text        ', "DPS")
test('test-number ', "DPS123")
test('address-number ', "DPS, somehwere, 123")
test('numbers,number ', "123, 123")
test('number-text ', "123DPS")
test('6 dgiti     ', "123456")
test('10 digit    ', "1234567980")
