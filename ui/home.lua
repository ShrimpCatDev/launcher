local home={}

function home:init(parent)
    self.selected=ui.panel(0,0,300,60,parent,{
        align={x="center",y="center"},
        margin={bottom=100,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=24,right=24},
        layout={mode="horizontal",spacing=12},
        highlight=theme.panel.fill.highlight
    })

    self.selectedText=ui.text(0,0,"Pokemon Emerald Version",self.selected,{
        align={x="center",y="center"},
        margin={bottom=0,top=0,left=0,right=0},
        font=theme.font.h1
    })

    self.selectionMenu=ui.custom(0,0,ui.w,200,function(self)
            local s=128
            local sb=192
            local selected=0

            for i=0,3 do
                if i==selected then
                    lg.rectangle("fill",i*(s+self.layout.spacing)+(self.w/2-sb/2),self.y+self.h-sb,sb,sb,10,10)
                else
                    lg.rectangle("fill",i*(s+self.layout.spacing)+(self.w/2-s/2),self.y+self.h-s,s,s,10,10)
                end
            end
        end,control,{
        align={x="center",y="bottom"},
        margin={bottom=64,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=12,right=12},
        layout={mode="horizontal",spacing=64}
    })
    return home
end

function home:update(dt)

end

function home:draw()

end

return home