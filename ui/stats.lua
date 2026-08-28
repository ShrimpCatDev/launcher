local stats={}

function stats:init(parent)
    --main control hi lol
    self.main=ui.control(0,0,400,50,parent,{
        align={x="left",y="top"},
        margin={bottom=10,top=12,left=12,right=12},
        padding={bottom=0,top=0,left=0,right=12},
        layout={mode="horizontal",spacing=12}
    }) 

    --profile picture hi lol
    self.profile=ui.custom(0,0,50,50,function(self)
        lg.setColor(color(theme.panel.fill.color))

        lg.stencil(function()
            lg.circle("fill",self.x+self.w/2,self.y+self.h/2,self.w/2)
        end,"replace",1)

        local s=pixel(self.h,self.profileData.image:getHeight())

        lg.setStencilTest("greater", 0)
            lg.draw(self.profileData.image,self.x,self.y,0,s,s)
        lg.setStencilTest()

        lg.setColor(1,1,1,1)
    end,self.main,

    {init=function(self)
        self.profileData=require("user")
    end})

    --page panel thing hi lol
    self.panel=ui.panel(0,0,300,50,nil,{
        align={x="left",y="top"},
        margin={bottom=0,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=12,right=12},
        layout={mode="horizontal",spacing=12}
    })
    
    --all of the icons! (hi lol)
    for k,v in pairs(dispIcons) do
        ui.image(0,0,v,self.panel,{
            align={x="left",y="center"},
            margin={bottom=0,top=0,left=0,right=0},
            class="icon"
        })
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