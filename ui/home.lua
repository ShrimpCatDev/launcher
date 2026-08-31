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

            lg.push()
            lg.translate(self.menuDraw,0)
                for i=0,3 do
                    if i==self.data.selection then
                        lg.rectangle("fill",i*(s+self.layout.spacing)+(self.w/2-sb/2),self.y+self.h-sb,sb,sb,10,10)
                    else
                        lg.rectangle("fill",i*(s+self.layout.spacing)+(self.w/2-s/2),self.y+self.h-s,s,s,10,10)
                    end
                end
            lg.pop()
        end,control,{
        align={x="center",y="bottom"},
        margin={bottom=64,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=12,right=12},
        layout={mode="horizontal",spacing=64},
        selection=0
    })
    self.selectionMenu.menuDraw=0

    parent.navigation:item(self.selectionMenu,2,nil,true)
    return home
end

function home:update(dt)
    local s=self.selectionMenu
    if s.focused then
        
        if input:pressed("left") then
            s.data.selection=s.data.selection-1
        end
        if input:pressed("right") then
            s.data.selection=s.data.selection+1
        end
    end
    s.menuDraw=lerpDt(s.menuDraw,-s.data.selection*(128+s.layout.spacing),18,dt)
end

function home:draw()

end

return home