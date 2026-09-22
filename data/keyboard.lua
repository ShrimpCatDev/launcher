return{
    special={
        ["Space"]={raw=" "},
        ["Enter"]={raw="",func=function(self)
            self:setOutput()
        end},
        ["Caps"]={raw="",func=function(self)
            self.capsLock=not self.capsLock
        end}
    },
    regular={
        {"q","w","e","r","t","y","u","i","o","p"},
        {"a","s","d","f","g","h","j","l"},
        {"z","x","c","v","b","n","m"},
        {"Caps","Space","Enter"}
    },
    caps={

    }
}