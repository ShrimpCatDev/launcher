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
    lg.setFont(lg.newFont("assets/fonts/contb.ttf",24))

    require("func")
    ui=require("ui")
    ui:init()

    uiCanvas=lg.newCanvas(ui.w,ui.h)

    control=ui.control(0,0,ui.w,ui.h)

    left=ui.control(0,0,400,50,control,{
        align={x="left",y="top"},
        margin={bottom=10,top=12,left=12,right=12},
        padding={bottom=0,top=0,left=0,right=12},
        layout={mode="horizontal",spacing=12}
    }) 

    panel2=ui.panel(0,0,300,50,control,{
            align={x="right",y="top"},
            margin={bottom=0,top=12,left=0,right=12},
            padding={bottom=0,top=0,left=12,right=12},
            layout={mode="horizontal",spacing=12}
    })

    time=ui.text(0,0,"00:00",panel2,{
        align={x="left",y="center"},
        margin={bottom=0,top=0,left=12,right=12}
    })

    panel=ui.panel(0,0,300,50,nil,{
        align={x="left",y="top"},
        margin={bottom=0,top=0,left=0,right=0},
        padding={bottom=0,top=0,left=12,right=12},
        layout={mode="horizontal",spacing=12}
    })

    for k,v in pairs(dispIcons) do
        ui.image(0,0,v,panel,{
            align={x="left",y="center"},
            margin={bottom=0,top=0,left=0,right=0}
        })
    end

    left:child(panel) 
end

function love.update()
    time.text=os.date("%H:%M")
end

function pixel(targetSize,currentSize)
    return targetSize/currentSize
end

function love.draw()
    lg.clear(color(theme.background.color))
    if theme.background.image then
        local i=theme.background.image
        local s=pixel(ui.h,i:getHeight())
        lg.draw(i,ui.w/2,ui.h/2,0,s,s,i:getWidth()/2,i:getHeight()/2)
    end

    control:draw()

    lg.setShader()
    lg.setColor(1,1,1,1)
end