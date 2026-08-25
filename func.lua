function rect(type,x,y,w,h,rx,ry)
    if type=="fill" then
        lg.rectangle("fill",x,y,w,h,rx,ry)
    end
    lg.rectangle("line",x,y,w,h,rx,ry)
end

function drawPanel(theme,x,y,w,h)
    local rad=(h*(theme.panel.radius/100))*0.5
    if theme.panel.shadow then
        local a=0
        local ca=theme.panel.shadow.opacity/theme.panel.shadow.radius/2

        for i=0,theme.panel.shadow.radius-1 do
            lg.setColor(color(theme.panel.shadow.color,ca))
            lg.rectangle("fill",(x+theme.panel.shadow.offsetX)-i/2,(y+theme.panel.shadow.offsetY)-i/2,w+i,h+i,rad,rad)
        end
    end
    lg.setColor(color(theme.panel.fill))
        rect("fill",x,y,w,h,rad,rad)
    lg.setColor(1,1,1,1)
end