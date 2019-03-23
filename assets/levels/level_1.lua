local BaseLvl = require "assets.levels.level"
local Region = require "assets.levels.region"

local Lvl = BaseLvl:subclass("Lvl1")

function Lvl:initialize(...)
    BaseLvl.initialize(self,...)
    self.regions = {
        Region("region_1",0,0,1)
    }

    self.figures = {
        Region("rect",0,0,33)
    }
end

return Lvl