local settings={}

function settings:init(parent,item)
    --[[ui.textInput(control,function(t)
        print(t)
    end)]]
    self.control=ui.control(0,0,ui.w,ui.h,parent,{
        align={x="center",y="center"},
        margin={bottom=0,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=0,right=0},
        layout={mode="vertical",spacing=12},
        class="overlay"
    })

    self.panel=ui.panel(0,0,ui.w-64,ui.h-64,self.control,{
        align={x="center",y="center"},
        margin={bottom=0,top=0,left=0,right=0},
        padding={bottom=24,top=24,left=0,right=0},
        layout={mode="vertical",spacing=12}
    })

    self.title=ui.text(0,0,item.name,self.panel,{
        align={x="center",y="top"},
        margin={bottom=0,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=0,right=0},
        layout={mode="vertical",spacing=12},
        font=theme.font.large
    })

    self.button=ui.button("Rename",self.panel,{
        align={x="center",y="center"}
    })
    self.button.press=function(self1)
        ui.textInput(control,function(t)
            local old=item.name
            item.name=t
            self.title.text=t
            self.title.w=self.title.font:getWidth(t)/globalScale
            self.panel:updateLayout()
            os.rename(item.root..item.raw,item.root..t.."."..item.extension)

            local dir=love.filesystem.getSaveDirectory()
            os.rename(dir.."/icons/"..old..".png",dir.."/icons/"..t..".png")
            --print(dir.."/icons/"..old..".png")
            item.parent:updateList()
        end)
    end
    self.control.navigation:item(self.button,1,1,true)

    self.button=ui.button("Scrape from SteamGridDB",self.panel,{
        align={x="center",y="center"}
    })
    self.button.press=function(self)
        item.img=scrape(item.name)
    end
    self.control.navigation:item(self.button,2)

    self.control.update=function(self,dt)
        if input:pressed("back") and stack.items[#stack.items]==self then
            self.hidden=true
            stack:remove(self)
            self=nil
        end
    end
    
    self.test=ui.toggle(self.panel,{
        align={x="center",y="center"},
        margin={bottom=0,top=0,left=0,right=0},
        class="toggle",
        focusable=true
    })
    self.control.navigation:item(self.test,3)

    

    stack:add(self.control)

    return settings
end

return settings