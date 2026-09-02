local home={}

function home:init(parent)
    self.selected=ui.panel(0,0,300,60,parent,{
        align={x="center",y="center"},
        margin={bottom=100,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=24,right=24},
        layout={mode="horizontal",spacing=12},
        highlight=theme.panel.fill.highlight
    })

    self.selectionMenu=ui.custom(0,0,ui.w,200,function(self)
            lg.push()
            lg.translate(self.menuDraw,0)
                for i,v in ipairs(self.items) do
                    --if i==self.data.selection-1 then
                        lg.rectangle("fill",(i-1)*(self.s+self.layout.spacing)+(self.w/2-v.scale/2),self.y+self.h-v.scale,v.scale,v.scale,10,10)
                    --end
                end
            lg.pop()
        end,control,{
        align={x="center",y="bottom"},
        margin={bottom=64,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=12,right=12},
        layout={mode="horizontal",spacing=64},
        selection=0
    })
    self.selectionMenu.items={}
    self.selectionMenu.s=128
    self.selectionMenu.sb=192

    self.selectionMenu.unfocus=function(self)
        timer.tween(0.2,self.items[self.data.selection+1],{scale=self.s},"out-cubic")
    end

    self.selectionMenu.focus=function(self)
        timer.tween(0.3,self.items[self.data.selection+1],{scale=self.sb},"out-back")
    end

    local roms=fs:scanFiles("/home/deck/Desktop/romz/")
    for k,v in ipairs(roms) do
        local name=v:match("(.+)%..+$")
        table.insert(self.selectionMenu.items,{scale=self.selectionMenu.s,name=name})
    end
    timer.tween(0.3,self.selectionMenu.items[self.selectionMenu.data.selection+1],{scale=self.selectionMenu.sb},"out-back")

    self.selectionMenu.menuDraw=0

    parent.navigation:item(self.selectionMenu,2,nil,true)

    self.selectedText=ui.text(0,0,self.selectionMenu.items[self.selectionMenu.data.selection+1].name or "",self.selected,{
        align={x="center",y="center"},
        margin={bottom=0,top=0,left=0,right=0},
        font=theme.font.h1
    })

    return home
end

function home:update(dt)
    local s=self.selectionMenu
    if s.focused and (input:pressed("left") or input:pressed("right")) then
        local prev=s.data.selection+1
        
        if input:pressed("left") then
            s.data.selection=s.data.selection-1
        end
        if input:pressed("right") then
            s.data.selection=s.data.selection+1
        end
        s.data.selection=clamp(s.data.selection,0,#self.selectionMenu.items-1)

        if s.data.selection+1~=prev then
            timer.tween(0.2,s.items[prev],{scale=s.s},"out-cubic")
            timer.tween(0.3,s.items[s.data.selection+1],{scale=s.sb},"out-back")
            local t=self.selectionMenu.items[self.selectionMenu.data.selection+1].name
            self.selectedText.text=t
            self.selectedText.w=self.selectedText.font:getWidth(t)
            self.selectedText:updateLayout()
            self.selected:updateLayout()
            sfx.nav:play()
        end
    end
    s.menuDraw=lerpDt(s.menuDraw,-s.data.selection*(128+s.layout.spacing),18,dt)
end

function home:draw()

end

return home