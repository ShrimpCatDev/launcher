lg=love.graphics

function love.load()
    moonshine=require("lib/moonshine")
    effect={
        blur=moonshine(moonshine.effects.boxblur)
    }

    bg=lg.newImage("Home.png")
    color=require("lib.hex2color")
    theme=require("themes.default")

    require("func")
    ui=require("ui")
    ui:init()

    print(ui:getPercentage(8))

    uiCanvas=lg.newCanvas(ui.width,ui.height)
end

function love.update()

end

function love.draw()
    lg.clear(color(theme.background.color))
    lg.setCanvas(uiCanvas)
        lg.clear(color(theme.background.color,0))
        local h,v=ui:getPercentage(25)
        drawPanel(theme,16,16,128,64)
        --lg.draw(bg)
    lg.setCanvas()

    lg.setShader()
    lg.setColor(1,1,1,1)
    lg.draw(uiCanvas,0,0)

    
end