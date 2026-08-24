lg=love.graphics

function love.load()
    bg=lg.newImage("assets/bg.png")
    color=require("lib.hex2color")
    theme=require("themes.default")

    require("func")
    ui=require("ui")
    ui:init()
end

function love.update()

end

function love.draw()
    lg.clear(1,1,1,1)
    lg.draw(bg)
    drawPanel(theme,ui:getPercentage(8),8,68,36)
end