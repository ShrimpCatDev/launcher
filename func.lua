function lerp(a,b,t)
    return a+(b-a)*t
end

function easeinquad(t)
	return t*t
end

function drawPanel(x,y,w,h)
    local rad=(h*(theme.panel.radius/100))*0.5
    if h>w then
        rad=(w*(theme.panel.radius/100))*0.5
    end

    lg.rectangle("fill",x,y,w,h,rad,rad)
end

function clamp(x, min, max)
    return math.max(min, math.min(x, max))
end

function lerpDt(current,target,speed,dt)
    return lerp(current,target,1-math.exp(-speed*dt))
end