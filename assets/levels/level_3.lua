local BaseLvl = require "assets.levels.level"
local Region = require "assets.levels.region"

local Lvl = BaseLvl:subclass("Lvl1")

function Lvl:initialize(...)
    BaseLvl.initialize(self,...)
    self.regions = {
        Region("region_3",0,0,1)
    }

    self.figures = {
        Region("circle",40,184,0.7)
    }
end

return Lvl