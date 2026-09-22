return{
    special={
        ["Space"]={raw=" "},
        ["Enter"]={raw="",func=function(self)
            self:setOutput()
        end},
        ["Caps"]={raw="",func=function(self)
            self.capsLock=not self.capsLock
        end},
        ["Backspace"]={raw="",func=function(self)
            self.text=string.sub(self.text,1,string.len(self.text)-1)
            self.print.text=self.text
        end}
    },
    regular={
        {"q","w","e","r","t","y","u","i","o","p","Backspace"},
        {"a","s","d","f","g","h","j","l"},
        {"z","x","c","v","b","n","m"},
        {"Caps","Space","Enter"}
    },
    caps={

    }
}