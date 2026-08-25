local ui={}

function ui:init()
    self.w,self.h=love.graphics.getDimensions()
end

function ui:getPercentage(percent)
    return self.w*(percent/100),self.h*(percent/100)
end

function ui:drawElement(data)

end

return ui