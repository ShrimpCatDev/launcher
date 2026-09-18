lg=love.graphics

function pixel(targetSize,currentSize)
    return targetSize/currentSize
end

json=require("lib/json")

local e=love.filesystem.getDirectoryItems("data/emulators")
emulators={}
print("EMULATORS:")
for k,v in ipairs(e) do
    print(v)
    table.insert(emulators,json.decode(love.filesystem.read("data/emulators/"..v)))
end

local p=love.filesystem.getDirectoryItems("data/platforms")
platforms={}
print("PLATFORMS:")
for k,v in ipairs(p) do
    print(v)
    table.insert(platforms,json.decode(love.filesystem.read("data/platforms/"..v)))
end

function getPlatform(extension)
    for k,v in ipairs(platforms) do
        for i,e in ipairs(v.extensions) do
            if e==extension then
                return v
            end
        end
    end
    return nil
end

function getEmulator(platform)
    for k,v in ipairs(emulators) do
        print(platform)
        if platform.emulator.backend==v.id then
            return v
        end
    end
    return nil
end

function love.load()
    love.graphics.setDefaultFilter("linear","linear")
    love.filesystem.write("README.txt","hi lol")

    nativefs=require("lib/nativefs")
    fs=require("fs")

    config=require("config")
    https=require("runtime/loader").loadHTTPS()

    debug=config.debug
    object=require("lib/classic")
    assert=require("lib/inspect")

    timer=require("lib/hump/timer")

    require("input")

    sfx={
        nav=love.audio.newSource("assets/sfx/navigate.mp3","static"),
        confirm=love.audio.newSource("assets/sfx/confirm.mp3","static"),
        toggle=love.audio.newSource("assets/sfx/toggle.ogg","static")
    }

    icons={
        home=lg.newImage("assets/icons/home.png",{mipmaps=true}),
        music=lg.newImage("assets/icons/music.png",{mipmaps=true}),
        social=lg.newImage("assets/icons/social.png",{mipmaps=true}),
        media=lg.newImage("assets/icons/media.png",{mipmaps=true}),
        ra=lg.newImage("assets/icons/ra.png",{mipmaps=true}),
        settings=lg.newImage("assets/icons/settings.png",{mipmaps=true}),
    }

    dispIcons={icons.home,icons.music,icons.social,icons.media,icons.ra,icons.settings}
    color=require("lib.hex2color")

    gradient=lg.newShader("shaders/gradient.frag")

    require("func")
    ui=require("ui")
    ui:init()

    local cw,ch=ui.w,ui.hu

    if config.changeAspect then
        local sw,sh=love.window.getDesktopDimensions()
        local ar=sw/sh
        local vw=math.floor(ui.h*ar)
        ui.w=vw
        cw,ch=sw,sh
    end
    
    profile=json.decode(love.filesystem.read("profile.json"))

    love.window.setMode(ui.w,ui.h,{fullscreen=false,msaa=2})

    uiCanvas=lg.newCanvas(cw,ch,{
        format = "rgba8",
        readable = true,
        msaa = 4
    })

    local w,h=love.graphics.getDimensions()
    globalScale=pixel(w,ui.w)

    screenW,screenH=love.window.getDesktopDimensions()
    theme=require("themes.default")
    lg.setFont(theme.font.regular)

    if theme.panel.fill.highlight and theme.panel.fill.highlight.gradient then
        gradient:send("colorA",color(theme.panel.fill.highlight.gradient[1]))
        gradient:send("colorB",color(theme.panel.fill.highlight.gradient[2]))
    elseif theme.panel.fill.highlight and theme.panel.fill.highlight.color then
        gradient:send("colorA",color(theme.panel.fill.highlight.color))
        gradient:send("colorB",color(theme.panel.fill.highlight.color))
    else
        gradient:send("colorA",color(theme.panel.fill.color))
        gradient:send("colorB",color(theme.panel.fill.color))
    end

    stack=ui.stack()

    control=ui.control(0,0,ui.w,ui.h)
    stack:add(control)

    ui.elements={
        home=require("ui/home"):init(control),
        stats=require("ui/stats"):init(control)
    }

    key=profile.steamgriddb

    ui.textInput(control)
end

function love.update(dt)
    timer.update(dt)
    input:update()
    stack:update(dt)
end

function love.draw()
    local w,h=love.graphics.getDimensions()
    lg.clear(color(theme.background.color))

    local w,h=love.graphics.getDimensions()
    if theme.background.image then
        local i=theme.background.image
        local s=math.max(pixel(h,i:getHeight()),pixel(w,i:getWidth()))
        
        lg.draw(i,w/2,h/2,0,s,s,i:getWidth()/2,i:getHeight()/2)
    end

    --ui.elements.home.bg:draw()

    lg.setCanvas{uiCanvas,stencil=true}
        lg.push()
        lg.scale(pixel(w,ui.w))
            lg.clear()
            stack:draw()
        lg.pop()
    lg.setCanvas()
    
    love.graphics.setBlendMode("alpha", "premultiplied")
        lg.setColor(0,0,0,0.1)
            love.graphics.draw(uiCanvas,2*globalScale,4*globalScale)
        lg.setColor(1,1,1,1)
            love.graphics.draw(uiCanvas)
    love.graphics.setBlendMode("alpha")
    

    lg.setColor(1,1,1,1)
end

function love.keypressed(k)
    if k=="escape" then
        love.event.quit()
    end
    if k=="f" and not stack.items[#stack.items].hasTextInput then
        print("opening folder")
        love.system.setClipboardText(love.filesystem.getSaveDirectory( ))
        local suc=love.system.openURL("file://"..love.filesystem.getSaveDirectory())
        print(suc)
    end
    if stack.items[#stack.items].hasTextInput then
        stack.items[#stack.items]:keyInput(k)
    end
end

function love.textinput(k)
    if stack.items[#stack.items].hasTextInput then
        stack.items[#stack.items]:keyTextInput(k)
    end
end