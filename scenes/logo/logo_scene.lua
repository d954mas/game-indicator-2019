local BaseScene = require "libs.sm.scene"
local SM = require "libs.sm.sm"
local LEVELS = require "assets.levels.levels"

---@class LogoScene:Scene
local Scene = BaseScene:subclass("LogoScene")
function Scene:initialize()
    BaseScene.initialize(self, "LogoScene", "/logo#proxy", "logo:/scene_controller")
end

function Scene:on_show(input)

end

function Scene:final(go_self)
end

function Scene:update(go_self, dt)
    BaseScene.update(self,go_self,dt)
    SM:show("GameScene",{lvl = LEVELS.LVL_1()})
end

function Scene:on_transition(transition)
    --[[if transition == self._TRANSITIONS.ON_SHOW then
        go.set("/go#sprite","tint.w",0)
        go.animate("/go#sprite","tint.w",go.PLAYBACK_ONCE_FORWARD,1,go.EASING_LINEAR,1)
        for i=1,60 do
            coroutine.yield()
        end
        SCHEDULER:schedule(function()
            SM:show("LogoScene2")
        end,0.2)
    elseif transition == self._TRANSITIONS.ON_HIDE then
        print("HIDE")
        go.animate("/go#sprite","tint.w",go.PLAYBACK_ONCE_FORWARD,0,go.EASING_LINEAR,1)
        for i=1,60 do
            coroutine.yield()
        end
    end--]]
end

return Scene