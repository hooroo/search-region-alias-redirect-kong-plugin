local access = require "../src/access"

describe ("access" , function ()

    local conf = {}
    conf.search_legacy_host = "bili"
    conf.search_legacy_path = "/availability"

    before_each(function()
        _G.ngx = {
            req = {},
            ctx = {
                balancer_address = {
                    host = "normal_server"
                }
            },
            var = {
                upstream_uri = "normal_path"
            }
        }
        function ngx.log()
            return
        end
    end)

    describe ("location param is region alias", function()
        before_each(function()
            function ngx.req.get_uri_args()
                return { location = "DPS"}
            end
        end)
        it ("should forward request to search legacy app", function()
            access.execute(conf)

            assert.equal(ngx.ctx.balancer_address.host, "bili")
            assert.equal(ngx.var.upstream_uri, "/availability")
        end)
    end)

    describe ("location param is region ID", function()
        before_each(function()
            function ngx.req.get_uri_args()
                return { location = "1234"}
            end
        end)
        it ("should forward request to normal path", function()

            access.execute(conf)

            assert.equal(ngx.ctx.balancer_address.host, "normal_server")
            assert.equal(ngx.var.upstream_uri, "normal_path")
        end)
    end)

    describe ("no location param", function()
        before_each(function()
            function ngx.req.get_uri_args()
                return { }
            end
        end)
        it ("should forward request to normal path", function()

            access.execute(conf)

            assert.equal(ngx.ctx.balancer_address.host, "normal_server")
            assert.equal(ngx.var.upstream_uri, "normal_path")
        end)
    end)

    describe ("location param is nil", function()
        before_each(function()
            function ngx.req.get_uri_args()
                return { location = ""}
            end
        end)
        it ("should forward request to normal path", function()

            access.execute(conf)

            assert.equal(ngx.ctx.balancer_address.host, "normal_server")
            assert.equal(ngx.var.upstream_uri, "normal_path")
        end)
    end)

end)