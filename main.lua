lg=love.graphics

function pixel(targetSize,currentSize)
    return targetSize/currentSize
end

function love.load()
    debug=false
    object=require("lib/classic")

    icons={
        home=lg.newImage("assets/icons/home.png"),
        music=lg.newImage("assets/icons/music.png"),
        social=lg.newImage("assets/icons/social.png"),
        media=lg.newImage("assets/icons/media.png"),
        ra=lg.newImage("assets/icons/ra.png"),
        settings=lg.newImage("assets/icons/settings.png"),
    }

    dispIcons={icons.home,icons.music,icons.social,icons.media,icons.ra,icons.settings}

    bg=lg.newImage("Home.png")
    color=require("lib.hex2color")
    theme=require("themes.default")
    lg.setFont(theme.font.regular)

    gradient=lg.newShader("shaders/gradient.frag")
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

    require("func")
    ui=require("ui")
    ui:init()

    uiCanvas=lg.newCanvas(ui.w,ui.h,{
        format = "rgba8",
        readable = true,
        msaa = 4
    })

    control=ui.control(0,0,ui.w,ui.h)

    ui.elements={
        stats=require("ui/stats"):init(control),
        home=require("ui/home"):init(control)
    }
end

function love.update(dt)
    for k,v in pairs(ui.elements) do
        v:update(dt)
    end
end

function love.draw()
    lg.clear(color(theme.background.color))

    if theme.background.image then
        local i=theme.background.image
        local s=math.max(pixel(ui.h,i:getHeight()),pixel(ui.w,i:getWidth()))
        
        lg.draw(i,ui.w/2,ui.h/2,0,s,s,i:getWidth()/2,i:getHeight()/2)
    end

    lg.setCanvas{uiCanvas,stencil=true}
        lg.clear()
        control:draw()
    lg.setCanvas()

    love.graphics.setBlendMode("alpha", "premultiplied")
        lg.setColor(0,0,0,0.1)
            love.graphics.draw(uiCanvas,2,4)
        lg.setColor(1,1,1,1)
            love.graphics.draw(uiCanvas)
    love.graphics.setBlendMode("alpha")

    lg.setColor(1,1,1,1)
end