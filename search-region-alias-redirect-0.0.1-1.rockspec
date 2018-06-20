package = "search-region-alias-redirect"
version = "0.0.1-1"

description = {
    summary = "A Kong plugin that redirect search by Region alias to legacy Bili",
    license = "Apache 2.0"
}
dependencies = {
    "lua ~> 5.3-1"
}

build = {
    type = "builtin",
    modules = {
        ["kong.plugins.search-region-alias-redirect.handler"] = "src/handler.lua",
        ["kong.plugins.search-region-alias-redirect.access"] = "src/access.lua",
        ["kong.plugins.search-region-alias-redirect.schema"] = "src/schema.lua"
    }
}

source = {
    url = ""
}