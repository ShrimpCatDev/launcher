local stats={}

function stats:init(parent)
    --main control hi lol
    self.main=ui.control(0,0,400,50,parent,{
        align={x="left",y="top"},
        margin={bottom=10,top=12,left=12,right=12},
        padding={bottom=0,top=0,left=0,right=12},
        layout={mode="horizontal",spacing=12},
    })

    --profile picture hi lol
    self.profile=ui.custom(0,0,50,50,function(self)
        --lg.setColor(color(theme.panel.fill.color))

        lg.stencil(function()
            lg.circle("fill",self.x+self.w/2,self.y+self.h/2,self.w/2)
        end,"replace",1)

        local s=pixel(self.h,self.profileData.image:getHeight())

        lg.setStencilTest("greater", 0)
            local w,h=self.profileData.image:getWidth()/2,self.profileData.image:getHeight()/2
            lg.draw(self.profileData.image,self.x+self.w/2,self.y+self.h/2,self.r,s,s,w,h)
        lg.setStencilTest()

        lg.setColor(1,1,1,1)
    end,self.main,

    {init=function(self)
        self.profileData=require("user")
    end})

    self.profile.focus=function(self)
        timer.tween(0.1,self,{r=math.rad(10),offsetY=-5},"out-cubic")
    end

    self.profile.unfocus=function(self)
        timer.tween(0.4,self,{offsetY=0},"in-bounce")
        timer.tween(0.4,self,{r=math.rad(0)},"out-cubic")
    end

    parent.navigation:item(self.profile,1)

    --page panel thing hi lol
    self.panel=ui.panel(0,0,300,50,nil,{
        align={x="left",y="top"},
        margin={bottom=0,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=12,right=12},
        layout={mode="horizontal",spacing=12}
    })
    self.panel.class="bar"
    
    --all of the icons! (hi lol)
    for k,v in pairs(dispIcons) do
        local item=ui.image(0,0,v,self.panel,{
            align={x="left",y="center"},
            margin={bottom=0,top=0,left=0,right=0},
            class="icon",
            focusable=true
        },28,28)

        item.focus=function(self)
            timer.tween(0.2,self,{offsetY=-3,color={unpack(theme.icons.overlayColorSelect)}},"out-cubic")
        end

        item.unfocus=function(self)
            timer.tween(0.2,self,{offsetY=0,color={unpack(theme.icons.overlayColor)}},"out-cubic")
        end

        parent.navigation:item(item,1)
    end

    --add the panel to the main control thing hi lol
    self.main:child(self.panel) 


    --things for stats like time and stuff
    self.stats=ui.panel(0,0,300,50,parent,{
        align={x="right",y="top"},
        margin={bottom=0,top=12,left=0,right=12},
        padding={bottom=0,top=0,left=16,right=16},
        layout={mode="horizontal",spacing=12}
    })
    self.stats.class="bar"

    self.battery=ui.custom(0,0,27,18,function(self)
        local w,h=self.img:getDimensions()
        local scale=math.min(self.w/w,self.h/h)

        state, percent, seconds = love.system.getPowerInfo()

        if percent>=40 then
            lg.setColor(color(theme.widget.color.battery.full))
        elseif percent >=20 then
            lg.setColor(color(theme.widget.color.battery.low))
        else
            lg.setColor(color(theme.widget.color.battery.empty))
        end

        lg.rectangle("fill",self.x+3,self.y+2,self.bmw*(percent/100),self.h-4)
        lg.setColor(color(theme.widget.color.regular))
            lg.draw(self.img,self.x,self.y,0,scale,scale)
        lg.setColor(1,1,1,1)
    end,self.stats,{
        align={x="left",y="center"},
        margin={bottom=0,top=0,left=0,right=0}
    })

    self.battery.img=lg.newImage("assets/icons/battery.png",{mipmaps=true})
    self.battery.bmw=self.battery.w-9

    self.clock=ui.text(0,0,"00:00",self.stats,{
        align={x="left",y="center"},
        margin={bottom=0,top=0,left=0,right=0}
    })

    self.clock.update=function(s)
        s.text=os.date("%H:%M")
    end
    return self
end

function stats:update(dt)
    
    
end


function stats:draw()

end

return stats