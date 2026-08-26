lg=love.graphics

function love.load()
    debug=false
    deep=require("lib/deep")
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

    uiCanvas=lg.newCanvas(ui.w,ui.h)

    control=ui.control(0,0,ui.w,ui.h)
    panel=ui.panel(0,0,300,50,control,{
        align={x="left",y="top"},
        margin={bottom=10,top=12,left=12,right=12},
        padding={bottom=0,top=0,left=12,right=12},
        layout={mode="horizontal",spacing=12}
    })

    for k,v in pairs(dispIcons) do
        test=ui.image(0,0,v,panel,{
            align={x="left",y="center"},
            margin={bottom=0,top=0,left=0,right=0}
        })
    end
end

function love.update()

end

function love.draw()
    lg.clear(color(theme.background.color))
    --lg.setCanvas(uiCanvas)
        --[[lg.clear(color(theme.background.color,0))
        local h,v=ui:getPercentage(25)
        drawPanel(theme,74,12,227,50)
        for i=0,#dispIcons-1 do
            lg.setColor(0.1,0.5,1)
            lg.rectangle("fill",(i*35)+74+14,0,dispIcons[i+1]:getWidth(),dispIcons[i+1]:getHeight())
            lg.draw(dispIcons[i+1],(i*35)+74+14,0)
        end
        drawPanel(theme,504,12,196,50)]]
        --lg.draw(bg)
        control:draw()
    --lg.setCanvas()

    lg.setShader()
    lg.setColor(1,1,1,1)
    --lg.draw(uiCanvas,0,0)

    
end