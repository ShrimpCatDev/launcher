local baton=require("lib/baton")

input=baton.new{
    controls={
        left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
        right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
        up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
        down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
        confirm = {'key:z', 'button:a'},
        back = {'key:x', 'button:b'}
    },
    joystick = love.joystick.getJoysticks()[1],
}
