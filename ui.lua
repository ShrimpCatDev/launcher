local ui={}

function ui:init()
    self.w,self.h=love.graphics.getDimensions()
end


--probably didnt need to make this a function but im lazy
function ui:getPercentage(percent)
    return self.w*(percent/100),self.h*(percent/100)
end

ui.navigation=object:extend()

function ui.navigation:new()
    self.nav={}
    self.navPos={}
    self.selected={row=1,col=1}
end

function ui.navigation:item(item,col,row,default)
    self.nav[col] = self.nav[col] or {}
    if not self.navPos[col] then self.navPos[col]=row or 1 end

    row=row or (#self.nav[col]+1)

    table.insert(self.nav[col],row,item)
    item.navigate = true
    
    if default then 
        self.selected={row=row,col=col}
        self.nav[self.selected.col][self.selected.row].focused=true
    end
end

function ui.navigation:input()
    local p=input:pressed("right") or input:pressed("left") or input:pressed("up") or input:pressed("down") or input:pressed("confirm")

    if not p then return end

    self.nav[self.selected.col][self.selected.row].focused=false
    if self.nav[self.selected.col][self.selected.row].unfocus then self.nav[self.selected.col][self.selected.row]:unfocus() end

    if input:pressed("right") then
        self.selected.row=self.selected.row+1
        self.selected.row=clamp(self.selected.row,1,#self.nav[self.selected.col])
    end
    if input:pressed("left") then
        self.selected.row=self.selected.row-1
        self.selected.row=clamp(self.selected.row,1,#self.nav[self.selected.col])
    end
    if input:pressed("down") then
        self.selected.col=self.selected.col+1
        self.selected.col=clamp(self.selected.col,1,#self.nav)
        self.selected.row=self.navPos[self.selected.col]
    end
    if input:pressed("up") then
        self.selected.col=self.selected.col-1
        self.selected.col=clamp(self.selected.col,1,#self.nav)
        self.selected.row=self.navPos[self.selected.col]
    end

    if input:pressed("confirm") then
        if self.nav[self.selected.col][self.selected.row].confirm then self.nav[self.selected.col][self.selected.row]:confirm() end
    end

    self.navPos[self.selected.col]=self.selected.row
    self.nav[self.selected.col][self.selected.row].focused=true
    if self.nav[self.selected.col][self.selected.row].focus then self.nav[self.selected.col][self.selected.row]:focus() end

end

--main ui control which is the root of everything :3
ui.control=object:extend()

function ui.control:new(x,y,w,h,parent,data)
    self.x=x or 0
    self.y=y or 0
    self.w=w or 0
    self.h=h or 0
    self.r=0

    self.parent=parent
    self.children={}

    self.data=data or {}

    self.align=self.data.align or {x="left",y="top"}
    self.margin=self.data.margin or {top=0,bottom=0,left=0,right=0}
    self.padding=self.data.padding or {top=0,bottom=0,left=0,right=0}

    self.offsetX=0
    self.offsetY=0
    self.offsetW=1
    self.offsetH=1

    self.layout=self.data.layout or {mode="absolute",spacing=0}

    self.input={}

    if self.parent then
        self.parent:child(self)
    end

    if self.data.init then self.data.init(self) end

    --self.focusable=self.data.focusable or false
    self.focused=false

    self.navigation=ui.navigation()
end

function ui.control:updateLayout()
    local w,h=love.graphics.getDimensions()

    for k,child in pairs(self.children) do
        child:updateLayout()
    end

    if self.layout.mode=="horizontal" and #self.children>0 then
        local cx=self.padding.left

        for k,child in ipairs(self.children) do
            child.x=cx+child.margin.left
            --child.y=self.padding.top+child.margin.top
            local add=0
            if k<#self.children then add=self.layout.spacing end
            cx=cx+child.w+child.margin.left+child.margin.right+add
        end
        self.w=cx+self.padding.right
    elseif self.layout.mode=="vertical" and #self.children>0 then
        local cy=self.padding.top

        for k,child in ipairs(self.children) do
            child.y=cy+child.margin.top
            --child.y=self.padding.top+child.margin.top
            local add=0
            if k<#self.children then add=self.layout.spacing end
            cy=cy+child.h+child.margin.top+child.margin.bottom+add
        end
        self.h=cy+self.padding.bottom
    end

    if self.parent then 
        w=self.parent.w
        h=self.parent.h 
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

    if self.navigate and self.focused and debug then
        lg.setColor(0.1,0.5,1,0.2)
        lg.rectangle("fill",0,0,self.w,self.h)
        lg.setColor(1,1,1,1)
    end
    lg.translate(0,0)
    lg.pop()
end

--panel system which is funsies
ui.panel=ui.control:extend()

function ui.panel:new(x,y,w,h,parent,data)
    ui.panel.super.new(self,x,y,w,h,parent,data)
    if data.highlight then
        self.highlight=true
        self.highlightCanvas=lg.newCanvas(self.w,self.h)

        lg.setCanvas(self.highlightCanvas)
            lg.rectangle("fill",self.x,self.y,self.w,self.h)
        lg.setCanvas()
    end
end

function ui.panel:draw()
    lg.push()
    lg.translate(self.offsetX,self.offsetY)
        local rad=(self.h*(theme.panel.radius/100))*0.5
        if self.h>self.w then
            rad=(self.w *(theme.panel.radius/100))*0.5
        end

        if self.highlight then
            lg.setShader(gradient)
                lg.stencil(function()
                    lg.rectangle("fill",self.x,self.y,self.w,self.h,rad,rad)
                end,"replace",1)

                lg.setStencilTest("greater", 0)
                    lg.draw(self.highlightCanvas,self.x,self.y)
                lg.setStencilTest()
            lg.setShader()


            if theme.panel.outline and theme.panel.outline.highlight then
                lg.setColor(color(theme.panel.outline.highlight.color,theme.panel.outline.highlight.opacity))
                local t=lg.getLineWidth()
                lg.setLineWidth(theme.panel.outline.highlight.thickness)
                lg.rectangle("line",self.x,self.y,self.w,self.h,rad,rad)
                lg.setLineWidth(t)
            end
        else
            lg.setColor(color(theme.panel.fill.color,theme.panel.fill.opacity))
            lg.rectangle("fill",self.x,self.y,self.w,self.h,rad,rad)

            if theme.panel.outline then
                lg.setColor(color(theme.panel.outline.color,theme.panel.outline.opacity))
                local t=lg.getLineWidth()
                lg.setLineWidth(theme.panel.outline.thickness)
                lg.rectangle("line",self.x,self.y,self.w,self.h,rad,rad)
                lg.setLineWidth(t)
            end
        end

        
        lg.setColor(1,1,1,1)

        self.super.draw(self)
    lg.pop()
end

function ui.panel:updateLayout()
    self.super.updateLayout(self)
    if self.highlight then

        self.highlightCanvas=lg.newCanvas(self.w,self.h)
        lg.setCanvas(self.highlightCanvas)
            --lg.setShader(gradient)
            lg.rectangle("fill",0,0,self.w,self.h)
            --lg.setShader()
        lg.setCanvas()
    end
end


--image system
ui.image=ui.control:extend()

function ui.image:new(x,y,image,parent,data)
    ui.panel.super.new(self,x,y,image:getWidth(),image:getHeight(),parent,data)
    self.image=image
    self.class=data.class
end

function ui.image:draw()
    lg.push()
    lg.translate(self.offsetX,self.offsetY)
        if debug then
            lg.setColor(0,0,1,0.5)
            lg.rectangle("fill",self.x,self.y,self.w,self.h)
            lg.setColor(1,1,1,1)
        end
        
        if self.class and self.class=="icon" then
            lg.setColor(color(theme.icons.overlayColor,theme.icons.opacity or 1))
        else
            lg.setColor(1,1,1,1)
        end

        --lg.setShader(gradient)
        lg.draw(self.image,self.x,self.y)
        lg.setShader()
        self.super.draw(self)
    lg.pop()
end

--text system
ui.text=ui.control:extend()

function ui.text:new(x,y,text,parent,data)
    self.font=data.font or theme.font.regular
    local s=1/globalScale
    ui.text.super.new(self,x,y,self.font:getWidth(text)*s,self.font:getHeight()*s,parent,data)
    self.text=text
end

function ui.text:draw()
    lg.push()
    lg.translate(self.offsetX,self.offsetY)
        local font=lg.getFont()
        lg.setFont(self.font)
            if self.parent.highlight then
                lg.setColor(color(theme.font.color.highlight))
            else
                lg.setColor(color(theme.font.color.default))
            end
            
            local s=1/globalScale
            lg.print(self.text,self.x,self.y,0,s,s)
            lg.setColor(1,1,1,1)
            self.super.draw(self)
        lg.setFont(font)
    lg.pop()
end

--custom system
ui.custom=ui.control:extend()

function ui.custom:new(x,y,w,h,drawFunction,parent,data)
    ui.panel.super.new(self,x,y,w,h,parent,data)
    self.drawFunc=drawFunction or function() end
end

function ui.custom:draw()
    lg.push()
    lg.translate(self.offsetX,self.offsetY)
    self:drawFunc()
    self.super.draw(self)
    lg.pop()
end

return ui