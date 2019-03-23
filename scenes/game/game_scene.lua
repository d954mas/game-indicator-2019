local BaseScene = require "libs.sm.scene"
local SM = require "libs.sm.sm"
local WORLD = require "world.world"
local COMMON = require "libs.common"
local MATCHER = require "scenes.game.matcher.matcher"

---@class GameScene:Scene
local Scene = BaseScene:subclass("GameScene")
function Scene:initialize()
    BaseScene.initialize(self, "GameScene", "/game#proxy", "game:/scene_controller")
end

function Scene:on_show()
    WORLD:set_lvl(self._input.lvl)
    COMMON.input_acquire("/gui#script")
    COMMON.input_acquire()
    COMMON.input_acquire("/gui#script")

end

function Scene:init(go_self)
    self.subscription = WORLD.rx:go_distinct(self.scheduler):subscribe(function (v)
        if v == WORLD.COMMANDS.BTN_ACCEPTED then
           self.start_pos = nil
            self.next_pos = nil
            MATCHER:render()
            timer.delay(0,false,function ()
            end)
        end
    end)
end


function Scene:final(go_self)
    self.subscription:unsubscribe()
    WORLD:dispose()
end

function Scene:update(go_self, dt)
    BaseScene.update(self,go_self,dt)
    if self.next_pos then
        msg.post("@render:", "draw_line", { start_point = self.start_pos, end_point = self.next_pos, color = vmath.vector4(1,0,0,0.3) } )
        local point_a = vmath.vector3(self.start_pos.x+540/2,self.start_pos.y+960/2,0)
        local point_b = vmath.vector3(self.next_pos.x+540/2,self.next_pos.y+960/2,0)
        local a = point_a.y - point_b.y
        local b = point_b.x - point_a.x
        local c = point_a.x * point_b.y - point_b.x * point_a.y
        model.set_constant("test_model#model","line",vmath.vector4(a,b,c,0))
    end
end

function Scene:on_input(go_self, action_id, action)
    if action_id == COMMON.HASHES.INPUT_TOUCH then
        if action.pressed then
            self.start_pos = screen_to_world(vmath.vector3(action.x, action.y,0))
        end
        self.next_pos = screen_to_world(vmath.vector3(action.x, action.y,0))
    end
end


return Scene