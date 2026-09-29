local scraper={}

function scraper:init()
    self.available=true
    self.thread=love.thread.newThread(love.filesystem.read("utils/thread/scraper.lua"))
    self.queue={}
end

function scraper:start(name,func)
    self.finish=func
    --[[if self.available then
        self.available=false
        self.thread:start(key,name)
    end]]
    table.insert(self.queue,{name=name,func=func})
    if #self.queue<=1 then
        self.available=false
        self.thread:start(key,self.queue[1].name)
    end
end

function scraper:update(dt)
    if not self.available then
        local info=love.thread.getChannel('output'):pop()
        if info then
            self.available=true
            --self.finish(info)
            local v=table.remove(self.queue,1)
            v.func(info)
            if #self.queue>=1 then
                self.available=false
                self.thread:start(key,self.queue[1].name)
            end
            print("meow")
        end
    end
end

return scraper