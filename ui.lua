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

    self.layout=self.data.layout or {mode="absolute",spacing=0}

    if self.parent then
        self.parent:child(self)
    end

end

function ui.control:updateLayout()
    local w,h=love.graphics.getDimensions()

    for _,child in pairs(self.children) do
        child:updateLayout()
    end

    if self.layout.mode=="horizontal" and #self.children>0 then
        local currentX=self.padding.left

        for _,child in ipairs(self.children) do
            child.x=currentX+child.margin.left
            --child.y=self.padding.top+child.margin.top
            local add=0
            if _<#self.children then add=self.layout.spacing end
            currentX=currentX+child.w+child.margin.left+child.margin.right+add
        end
        self.w=currentX+self.padding.right
    elseif self.layout.mode=="vertical" and #self.children>0 then
        local currentY=self.padding.top

        for _,child in ipairs(self.children) do
            child.y=currentY+child.margin.top
            --child.y=self.padding.top+child.margin.top
            local add=0
            if _<#self.children then add=self.layout.spacing end
            currentY=currentY+child.h+child.margin.top+child.margin.bottom+add
        end
        self.h=currentY+self.padding.bottom
    end

    --local pl,pr,pu,pd=0,0,0,0
    if self.parent then 
        w=self.parent.w
        h=self.parent.h 
        --[[pl=self.parent.padding.left
        pr=self.parent.padding.right
        pu=self.parent.padding.up
        pd=self.parent.padding.down]]
    end

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
    drawPanel(theme,self.x,self.y,self.w,self.h)
    self.super.draw(self)
end

ui.image=ui.control:extend()

function ui.image:new(x,y,image,parent,data)
    ui.panel.super.new(self,x,y,image:getWidth(),image:getHeight(),parent,data)
    self.image=image
end

function ui.image:draw()
    if debug then
        lg.setColor(0,0,1,0.5)
        lg.rectangle("fill",self.x,self.y,self.w,self.h)
        lg.setColor(1,1,1,1)
    end
    
    lg.draw(self.image,self.x,self.y)
    self.super.draw(self)
end

ui.text=ui.control:extend()


function ui.text:new(x,y,text,parent,data)
    local font=lg.getFont()
    ui.text.super.new(self,x,y,font:getWidth(text),font:getHeight(),parent,data)
    self.text=text
end

function ui.text:draw()
    lg.setColor(color(theme.panel.font.color))
    lg.print(self.text,self.x,self.y)
    lg.setColor(1,1,1,1)
    self.super.draw(self)
end

ui.custom=ui.control:extend()

function ui.custom:new(x,y,w,h,drawFunction,parent,data)
    ui.panel.super.new(self,x,y,w,h,parent,data)
    self.drawFunc=drawFunction or function() end
end

function ui.custom:draw()
    self:drawFunc()
    self.super.draw(self)
end

return ui