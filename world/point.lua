local COMMON = require "libs.common"

local Point = COMMON.class("Point")

function Point:initialize(x,y)
    self.x, self.y = assert(x), assert(y)
end
