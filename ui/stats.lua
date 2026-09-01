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
        lg.setColor(color(theme.panel.fill.color))

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
    
    --all of the icons! (hi lol)
    for k,v in pairs(dispIcons) do
        local item=ui.image(0,0,v,self.panel,{
            align={x="left",y="center"},
            margin={bottom=0,top=0,left=0,right=0},
            class="icon",
            focusable=true
        })

        item.focus=function(self)
            timer.tween(0.2,self,{offsetY=-3,r=math.rad(math.random(-10,10)),color={unpack(theme.icons.overlayColorSelect)}},"out-cubic")
        end

        item.unfocus=function(self)
            timer.tween(0.2,self,{offsetY=0,r=0,color={unpack(theme.icons.overlayColor)}},"out-cubic")
        end

        parent.navigation:item(item,1)
    end

    --add the panel to the main control thing hi lol
    self.main:child(self.panel) 


    --things for stats like time and stuff
    self.stats=ui.panel(0,0,300,50,parent,{
        align={x="right",y="top"},
        margin={bottom=0,top=12,left=0,right=12},
        padding={bottom=0,top=0,left=12,right=12},
        layout={mode="horizontal",spacing=12}
    })

    self.clock=ui.text(0,0,"00:00",self.stats,{
        align={x="left",y="center"},
        margin={bottom=0,top=0,left=12,right=12}
    })
    return self
end

function stats:update(dt)
    self.clock.text=os.date("%H:%M")
    
end


function stats:draw()

end

return stats