profile=json.decode(love.filesystem.read("profile.json"))
local p=love.filesystem.read("profile.png")

local img=lg.newImage("assets/icons/user.png",{mipmaps=true})
if p then
    img=lg.newImage("profile.png")
end

return{
    name=profile.name,
    image=img
}