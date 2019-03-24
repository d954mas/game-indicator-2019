local BaseLvl = require "assets.levels.level"
local Region = require "assets.levels.region"

local Lvl = BaseLvl:subclass("Lvl1")

function Lvl:initialize(...)
    BaseLvl.initialize(self,...)
    self.regions = {
        Region("region_5",0,0,1)
    }

    self.figures = {
        Region("rect",-300,0,3)
    }
end

return Lvl