function rect(type,x,y,w,h,rx,ry)
    if type=="fill" then
        lg.rectangle("fill",x,y,w,h,rx,ry)
    end
    lg.rectangle("line",x,y,w,h,rx,ry)
end

function lerp(a,b,t)
    return a+(b-a)*t
end


function easeinquad(t)
	return t*t
end

function drawPanel(theme,x,y,w,h)
    local rad=(h*(theme.panel.radius/100))*0.5
    if h>w then
        rad=(w*(theme.panel.radius/100))*0.5
    end

    
    
    if theme.panel.shadow then
        
        local radius=theme.panel.shadow.radius
        local opacity=theme.panel.shadow.opacity

        for i=theme.panel.shadow.radius-1,0,-1 do
            local t=i/radius
            local fall=(1-t)^2
            local alpha=opacity*fall/radius
            lg.setColor(color(theme.panel.shadow.color,alpha))
            lg.rectangle("fill",
            (x+theme.panel.shadow.offsetX)-i/2,
            (y+theme.panel.shadow.offsetY)-i/2,
            w+i,
            h+i,
            rad,rad)
        end
    end

    lg.setColor(color(theme.panel.fill.color,theme.panel.fill.opacity))
        rect("fill",x,y,w,h,rad,rad)
    if theme.panel.outline then
        lg.setColor(color(theme.panel.outline.color,theme.panel.outline.opacity))
        local t=lg.getLineWidth()
        lg.setLineWidth(theme.panel.outline.thickness)
        rect("line",x,y,w,h,rad,rad)
        lg.setLineWidth(t)
    end
    lg.setColor(1,1,1,1)
end