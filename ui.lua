local ui={}

function ui:init()
    self.w,self.h=love.graphics.getDimensions()
end

function ui:getPercentage(percent)
    return self.w*(percent/100),self.h*(percent/100)
end

function ui:drawElement(data)

end

ui.control=object:extend()

function ui.control:new(x,y,w,h,parent,data)
    self.x=x or 0
    self.y=y or 0
    self.w=w or 0
    self.h=h or 0

    self.parent=parent
    self.children={}

    self.data=data or {}

    self.align=self.data.align or {x="left",y="top"}
    self.margin=self.data.margin or {top=0,bottom=0,left=0,right=0}
    self.padding=self.data.padding or {top=0,bottom=0,left=0,right=0}

    if self.parent then
        self.parent:child(self)
    end

end

function ui.control:updateLayout()
    local w,h=love.graphics.getDimensions()
    if self.align.x=="left" then
        self.x=self.margin.left
    elseif self.align.x=="right" then
        self.x=w-self.w-self.margin.right
    elseif self.align.x=="center" then
        self.x=(w/2)-(self.w/2)-self.margin.right+self.margin.left
    end

    if self.align.y=="top" then
        self.y=self.margin.top
    elseif self.align.y=="bottom" then
        self.y=h-self.h-self.margin.bottom
    elseif self.align.y=="center" then
        self.y=(h/2)-(self.h/2)-self.margin.bottom+self.margin.top
    end

    for _,child in pairs(self.children) do
        child:updateLayout()
    end
end

function ui.control:child(child)
    child.parent=self
    table.insert(self.children,child)

    self:updateLayout()
end

function ui.control:draw()
    lg.push()
    lg.translate(self.x,self.y)
    for k,v in pairs(self.children) do
        v:draw()
    end
    lg.translate(0,0)
    lg.pop()
end

ui.panel=ui.control:extend()

function ui.panel:new(x,y,w,h,parent,data)
    ui.panel.super.new(self,x,y,w,h,parent,data)
end

function ui.panel:draw()
    lg.rectangle("fill",0,600,64,64)
    self.super.draw(self)

    drawPanel(theme,self.x,self.y,self.w,self.h)
end

return ui