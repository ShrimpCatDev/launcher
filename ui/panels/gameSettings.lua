local settings={}

function settings:init(parent,item)
    self.control=ui.control(0,0,ui.w,ui.h,nil,{
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

    ui.text(0,0,item.name,self.panel,{
        align={x="center",y="top"},
        margin={bottom=0,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=0,right=0},
        layout={mode="vertical",spacing=12},
        font=theme.font.large
    })

    self.control.update=function(self,dt)
        if input:pressed("back") and stack.items[#stack.items]==self then
            self.hidden=true
            stack:remove(self)
        end
    end

    stack:add(self.control)

    return settings
end

return settings