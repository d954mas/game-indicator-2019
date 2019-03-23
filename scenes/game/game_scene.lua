local BaseScene = require "libs.sm.scene"
local SM = require "libs.sm.sm"
local WORLD = require "world.world"

---@class GameScene:Scene
local Scene = BaseScene:subclass("GameScene")
function Scene:initialize()
    BaseScene.initialize(self, "GameScene", "/game#proxy", "game:/scene_controller")
end

function Scene:on_show()
    WORLD:set_lvl(self._input.lvl)
end

function Scene:final(go_self)
    WORLD:dispose()
end

function Scene:update(go_self, dt)
    BaseScene.update(self,go_self,dt)
end


return Scene