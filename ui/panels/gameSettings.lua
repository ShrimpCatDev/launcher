local settings={}

function settings:init(parent,item)
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

    ui.text(0,0,item.name,self.panel,{
        align={x="center",y="top"},
        margin={bottom=0,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=0,right=0},
        layout={mode="vertical",spacing=12},
        font=theme.font.large
    })

    local a=ui.text(0,0,"Scrape",self.panel,{
        align={x="center",y="top"},
        margin={bottom=0,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=0,right=0},
        layout={mode="vertical",spacing=12},
        font=theme.font.large
    })
    a.confirm=function(self)
        local name=string.gsub(item.name," ","_")
        name=string.gsub(name,"'","")
        name=string.gsub(name,'"',"")
        print("Trying to scrape "..name)

        local code,result=https.request("https://www.steamgriddb.com/api/v2/search/autocomplete/"..name,{
            headers={
                ["Authorization"]="Bearer " .. key
            }
        })

        local ids=json.decode(result)
        print(assert(ids))

        if ids.data and #ids.data>1 then
            print("id found! YOINKING some icons :3")
            local id=ids.data[1].id

            local code,result=https.request("https://www.steamgriddb.com/api/v2/icons/game/"..id,{
                headers={
                    ["Authorization"]="Bearer " .. key
                }
            })
            local icons=json.decode(result)
            print(assert(icons))
            local imgUrl

            for k,v in ipairs(icons.data) do
                if v.url:lower():match("%.png") and v.width>=256 and v.language=="en" then
                    imgUrl=v.url
                end
            end

            print("downloading icon!")
            local code,result=https.request(imgUrl)
            local file=love.filesystem.write("icons/"..item.name..".png",result)

            local contents,size=love.filesystem.read("icons/"..item.name..".png")
            if contents then
                local data=love.image.newImageData(love.filesystem.newFileData(contents,size))
                item.img=love.graphics.newImage(data)
            end
        end
        
    end
    self.control.navigation:item(a,1,1,true)

    self.control.update=function(self,dt)
        if input:pressed("back") and stack.items[#stack.items]==self then
            self.hidden=true
            stack:remove(self)
        end
    end
    
    self.test=ui.toggle(self.panel,{
        align={x="center",y="center"},
        margin={bottom=0,top=0,left=0,right=0},
        class="toggle",
        focusable=true
    })
    self.control.navigation:item(self.test,2)

    stack:add(self.control)

    return settings
end

return settings