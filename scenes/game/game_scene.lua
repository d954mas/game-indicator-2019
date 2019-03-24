local BaseScene = require "libs.sm.scene"
local SM = require "libs.sm.sm"
local WORLD = require "world.world"
local COMMON = require "libs.common"
local MATCHER = require "scenes.game.matcher.matcher"
local RX = require "libs.rx"

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
    sprite.set_constant("/line_top#sprite","tint", vmath.vector4(0,0,1,1))

    timer.delay(0.1,false,function () MATCHER:render() end)
    timer.delay(0.2,false,function ()
        ---@type Level
        local  lvl = self._input.lvl
        for _,figure in ipairs(lvl.go_figures)do
            pprint(figure)
            go.delete(figure)
        end
    end)

end

function Scene:init(go_self)
    go.set_position(vmath.vector3(10000,10000,0),"/line_top#sprite")
    go.set_position(vmath.vector3(10000,10000,0),"/line_bottom#sprite")
    self.start_pos = nil
    self.next_pos = nil
    self.touch_pos = nil
    self.subscriptions = RX.SubscriptionsStorage()
    self.subscriptions:add(WORLD.rx:go_distinct(self.scheduler):subscribe(function (v)
        if v == WORLD.COMMANDS.BTN_ACCEPTED then
           self.start_pos = nil
            self.next_pos = nil
            self.touch_pos = nil
            go.set_position(vmath.vector3(10000,10000,0),"/line_top#sprite")
            go.set_position(vmath.vector3(10000,10000,0),"/line_bottom#sprite")
            MATCHER:render()
        elseif v == WORLD.COMMANDS.BTN_MIRROR then
            local pos = self.start_pos
            self.start_pos = self.next_pos
            self.next_pos = pos
        elseif v == WORLD.COMMANDS.BTN_CANCEL then
            self.start_pos.x = -10000
            self.start_pos.y = 10000
            self.next_pos.x = 10000
            self.next_pos.y = 10000
            self.touch_pos = nil
            go.set_position(vmath.vector3(10000,10000,0),"/line_top#sprite")
        end
    end))

end


function Scene:final(go_self)
    self.subscriptions:unsubscribe()
    WORLD:dispose()
end

function Scene:update(go_self, dt)
    BaseScene.update(self,go_self,dt)
    if self.next_pos then
       -- pprint(self.start_pos)
        local y_offset = (p_h - 960)/2
        local x_offset = (p_w - 540)/2
        local scale_x = 540/p_w
        local scale_y = 960/p_h
        local start_pos= vmath.vector3(self.start_pos.x,self.start_pos.y,0)
        local end_pos = vmath.vector3(self.next_pos.x,self.next_pos.y,0)
        model.set_constant("test_model#model","screen",vmath.vector4(p_w,p_h,0,0))

        -- pprint(start_pos)
       -- pprint(self.start_pos)
    local point_a = vmath.vector3(self.start_pos.x+p_w/2,self.start_pos.y+p_h/2,0)
    local point_b = vmath.vector3(self.next_pos.x+p_w/2,self.next_pos.y+p_h/2,0)
      --  pprint(point_a)
     --   pprint(point_b)
        local a = point_a.y - point_b.y
        local b = point_b.x - point_a.x
        local c = point_a.x * point_b.y - point_b.x * point_a.y
        model.set_constant("test_model#model","line",vmath.vector4(a,b,c,0))

        --pprint(point_a)
       --pprint(point_b)
    a = start_pos.y - end_pos.y
    b = end_pos.x - start_pos.x
    c = start_pos.x * end_pos.y - end_pos.x * start_pos.y



        local p1 = vmath.vector3(-540/2,(540/2 * a-c)/b,0)
        local p2 = vmath.vector3(540/2,(-540/2 * a-c)/b,0)

        local a = point_a.y - point_b.y
        local b = point_b.x - point_a.x
        local c = point_a.x * point_b.y - point_b.x * point_a.y

        local p1a = vmath.vector3(-540/2,(540/2 * a-c)/b,0)
        local p2a = vmath.vector3(540/2,(-540/2 * a-c)/b,0)
        --pprint(p1)
       -- pprint(p2)
    msg.post("@render:", "draw_line", { start_point = p1, end_point = p2, color = vmath.vector4(1,0,0,0.3) } )
   -- msg.post("@render:", "draw_line", { start_point = p1a, end_point = p2a, color = vmath.vector4(1,1,0,0.3) } )
        go.set_position(self.start_pos,"/line_top#sprite")
        go.set_position(self.next_pos,"/line_bottom#sprite")
    end

end

function Scene:on_input(go_self, action_id, action)
    if action_id == COMMON.HASHES.INPUT_TOUCH then
        local touch_pos = screen_to_world(vmath.vector3(action.x, action.y,0))
        if action.pressed then
            if self.start_pos and self.start_pos.x == -10000 and self.start_pos.y == 10000 then
                self.start_pos = nil
                self.next_pos = nil
            end
            if self.start_pos then
                local point_a = vmath.vector3(self.start_pos.x,self.start_pos.y,0)
                local point_b = vmath.vector3(self.next_pos.x,self.next_pos.y,0)

                local a = point_a.y - point_b.y
                local b = point_b.x - point_a.x
                local c = point_a.x * point_b.y - point_b.x * point_a.y
                local d = a * touch_pos.x + b* touch_pos.y + c
                if math.abs(d) > 200000 then
                    self.start_pos = touch_pos
                end
                local dist = math.sqrt((touch_pos.x - self.start_pos.x)^2 + (touch_pos.y - self.start_pos.y)^2)
                if dist < 40 then
                    self.touch_pos = touch_pos
                end
            else
                self.start_pos = touch_pos
            end
        end
        if self.touch_pos then
            local dx = touch_pos.x - self.touch_pos.x
            local dy = touch_pos.y - self.touch_pos.y
            self.touch_pos = touch_pos
            self.start_pos.x = self.start_pos.x + dx
            self.start_pos.y = self.start_pos.y + dy
        else
            self.next_pos = screen_to_world(vmath.vector3(action.x, action.y,0))
        end

        if action.released then
            self.touch_pos = nil
        end
    end
end


return Scene