lg=love.graphics

function love.load()
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

    require("func")
    ui=require("ui")
    ui:init()

    print(ui:getPercentage(8))

    uiCanvas=lg.newCanvas(ui.width,ui.height)

    control=ui.control(0,0,256,64)
    control:child(ui.panel(0,0,256,64,nil,control))
end

function love.update()

end

function love.draw()
    lg.clear(color(theme.background.color))
    lg.setCanvas(uiCanvas)
        lg.clear(color(theme.background.color,0))
        local h,v=ui:getPercentage(25)
        drawPanel(theme,74,12,227,50)
        for i=0,#dispIcons-1 do
            lg.setColor(0.1,0.5,1)
            lg.rectangle("fill",(i*35)+74+14,0,dispIcons[i+1]:getWidth(),dispIcons[i+1]:getHeight())
            lg.draw(dispIcons[i+1],(i*35)+74+14,0)
        end
        drawPanel(theme,504,12,196,50)
        --lg.draw(bg)
        control:draw()
    lg.setCanvas()

    lg.setShader()
    lg.setColor(1,1,1,1)
    lg.draw(uiCanvas,0,0)

    
end