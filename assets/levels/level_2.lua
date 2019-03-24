local BaseLvl = require "assets.levels.level"
local Region = require "assets.levels.region"

local Lvl = BaseLvl:subclass("Lvl1")

function Lvl:initialize(...)
    BaseLvl.initialize(self,...)
    self.regions = {
        Region("region_2",0,0,1)
    }

    self.figures = {
        Region("circle",0,-120,0.5)
    }
end

return Lvl