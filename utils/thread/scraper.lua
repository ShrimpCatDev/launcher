key,name=...

require("func")
require("love.image")
require("love.system")

if love.getVersion()==12 then
    https=require("https")
else
    https=require("runtime.loader").loadHTTPS()
end

local o=scrape(name)
love.thread.getChannel('output'):push(o)