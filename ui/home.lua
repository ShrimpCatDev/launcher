local home={}

function home:init(parent)
    self.bg=ui.custom(0,0,ui.w,ui.h-100,function(self)
        lg.draw(self.mesh,self.x,self.y)
    end,parent,{
        align={x="center",y="bottom"}
    })

    self.bg.img=lg.newImage("assets/default.png",{mipmaps=true})
    local w,h=self.bg.w,self.bg.h
    local vertices = {
        {0, 0,    0, 0,   1, 1, 1, 0},
        {w, 0,    1, 0,   1, 1, 1, 0},
        {w, h,    1, 1,   1, 1, 1, 1 },
        {0, h,    0, 1,   1, 1, 1, 1 }
    }
    self.bg.mesh=lg.newMesh(vertices,"fan","static")
    self.bg.mesh:setTexture(self.bg.img)
    self.bg.hidden=true

    self.selected=ui.panel(0,0,300,60,parent,{
        align={x="center",y="center"},
        margin={bottom=100,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=24,right=24},
        layout={mode="horizontal",spacing=12},
        highlight=theme.panel.fill.highlight
    })
    self.selected.shadow=true

    self.selectionMenu=ui.custom(0,0,ui.w,200,function(self)
            lg.push()
            lg.translate(self.menuDraw,0)
                local k=0
                for i,v in ipairs(self.items) do
                    local x=(i-1)*(self.s+self.layout.spacing)+(self.w/2-v.scale/2)
                    local y=self.y+self.h-v.scale
                    lg.rectangle("fill",x,y,v.scale,v.scale,16,16)

                    local o=v.scale*0.08
                    local img=v.img
                    local s=pixel(v.scale-(o*2),img:getWidth())
                    lg.stencil(function()
                        lg.rectangle("fill",x+o,self.y+self.h-v.scale+o,v.scale-(o*2),v.scale-(o*2),10,10) 
                    end,replace,1)
                    lg.setStencilTest("greater", 0)
                    lg.draw(img,x+o,self.y+self.h-v.scale+o,0,s,s)
                    lg.setStencilTest()
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

    self.first=true
    self.updateList=function(self,sel)
        self.selectionMenu.items={}
        self.selectionMenu.data.selection=0
        local path=profile.roms
        local roms=fs:scanFiles(path)
        for k,v in ipairs(roms) do
            local name=v:match("(.+)%..+$")
            local ext=v:match("%.(.+)$")
            local p=getPlatform(ext)

            local img=theme.games.default
            local contents,size=love.filesystem.read("icons/"..name..".png")

            if contents then
                local data=love.image.newImageData(love.filesystem.newFileData(contents,size))
                img=love.graphics.newImage(data,{mipmaps=true})
            end

            table.insert(self.selectionMenu.items,{scale=self.selectionMenu.s,name=name,img=img,path=path..v,platform=p,raw=v,root=path,extension=ext,parent=self,index=k})

            if sel and self.selectionMenu.items[#self.selectionMenu.items].name==sel.name then
                self.selectionMenu.data.selection=k-1
            end
        end

        
        if self.first then
            self.first=false
        else
            timer.tween(0.3,self.selectionMenu.items[self.selectionMenu.data.selection+1],{scale=self.selectionMenu.sb},"out-back")
            self.selectedText.text=self.selectionMenu.items[self.selectionMenu.data.selection+1].name
            self.selectedText.w=self.selectedText.font:getWidth(self.selectionMenu.items[self.selectionMenu.data.selection+1].name)/globalScale
            self.selectedText:updateLayout()
            self.selected:updateLayout()
        end

        
    end
    self:updateList()

    self.selectionMenu.menuDraw=0

    parent.navigation:item(self.selectionMenu,2,nil,true)

    self.selectedText=ui.text(0,0,self.selectionMenu.items[self.selectionMenu.data.selection+1].name or "",self.selected,{
        align={x="center",y="center"},
        margin={bottom=0,top=0,left=0,right=0},
        font=theme.font.h1
    })

    local se=self
    self.selectionMenu.update=function(self,dt)
        if self.focused and (input:pressed("left") or input:pressed("right") or input:pressed("options")) and stack.items[#stack.items]==parent then
            local prev=self.data.selection+1
            
            if input:pressed("left") then
                self.data.selection=self.data.selection-1
            end
            if input:pressed("right") then
                self.data.selection=self.data.selection+1
            end
            self.data.selection=clamp(self.data.selection,0,#self.items-1)

            if self.data.selection+1~=prev then
                timer.tween(0.2,self.items[prev],{scale=self.s},"out-cubic")
                timer.tween(0.3,self.items[self.data.selection+1],{scale=self.sb},"out-back")
                local t=self.items[self.data.selection+1].name
                se.selectedText.text=t
                se.selectedText.w=se.selectedText.font:getWidth(t)/globalScale
                se.selectedText:updateLayout()
                se.selected:updateLayout()
                sfx.nav:play()
            end

            if input:pressed("options") then
                local s=require("ui/panels/gameSettings"):init(control,self.items[self.data.selection+1])
            end
        end
        self.menuDraw=lerpDt(self.menuDraw,-self.data.selection*(128+self.layout.spacing),18,dt)
    end

    --flatpak run org.libretro.RetroArch -L ~/.var/app/org.libretro.RetroArch/config/retroarch/cores/mgba_libretro.so "/home/joseph/Desktop/romz/Pokemon - Emerald Version.gba"

    self.selectionMenu.confirm=function(self)
        --local c='/usr/bin/flatpak run org.libretro.RetroArch -L ~/.var/app/org.libretro.RetroArch/config/retroarch/cores/mgba_libretro.so "'..self.items[self.data.selection+1].path..'"'
        local c=""
        local item=self.items[self.data.selection+1]
        if item.platform then
            local e=getEmulator(item.platform)
            c=e.command
            for k,v in ipairs(e.args) do
                c=c.." "..v
            end

            if e.cores and item.platform.emulator.core then
                c=string.gsub(c,"{core}",e.cores..item.platform.emulator.core)
            end
            c=string.gsub(c,"{rom}",'"'..item.path..'"')
        end
        
        os.execute(c)
    end

    return home
end

function home:update(dt)

end

function home:draw()

end

return home
