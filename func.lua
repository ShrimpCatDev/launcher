function rect(type,x,y,w,h,rx,ry)
    if type=="fill" then
        lg.rectangle("fill",x,y,w,h,rx,ry)
    end
    lg.rectangle("line",x,y,w,h,rx,ry)
end

function drawPanel(theme,x,y,w,h)
    if theme.panel.shadow then
        lg.setColor(color(theme.panel.shadow.color),theme.panel.shadow.opacity)
        lg.rectangle("fill",x+theme.panel.shadow.offsetX,y+theme.panel.shadow.offsetY,w,h,theme.panel.radius,theme.panel.radius)
    end
    lg.setColor(color(theme.panel.fill))
        rect("fill",x,y,w,h,theme.panel.radius,theme.panel.radius)
    lg.setColor(1,1,1,1)
end