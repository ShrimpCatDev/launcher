function lerp(a,b,t)
    return a+(b-a)*t
end

function easeinquad(t)
	return t*t
end

function drawPanel(x,y,w,h)
    local rad=(h*(theme.panel.radius/100))*0.5
    if h>w then
        rad=(w*(theme.panel.radius/100))*0.5
    end

    lg.rectangle("fill",x,y,w,h,rad,rad)
end

function clamp(x, min, max)
    return math.max(min, math.min(x, max))
end

function lerpDt(current,target,speed,dt)
    return lerp(current,target,1-math.exp(-speed*dt))
end

function scrape(game)
    local name=string.gsub(game," ","_")
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
        local file=love.filesystem.write("icons/"..game..".png",result)

        local contents,size=love.filesystem.read("icons/"..game..".png")
        if contents then
            local data=love.image.newImageData(love.filesystem.newFileData(contents,size))
            return love.graphics.newImage(data)
        end
    end
end