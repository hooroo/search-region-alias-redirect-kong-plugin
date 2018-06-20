local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.search-region-alias-redirect.access"
local SearchRegionAliasRedirectHandler = BasePlugin:extend()

function SearchRegionAliasRedirectHandler:new()
    SearchRegionAliasRedirectHandler.super.new(self, "search-region-alias-redirect")
end

function SearchRegionAliasRedirectHandler:access(config)
    SearchRegionAliasRedirectHandler.super.access(self)
    access.execute(config)

end

return SearchRegionAliasRedirectHandler