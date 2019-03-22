local COMMON = require "libs.common"
local ECS = require "libs.ecs"
local SYSTEMS = require "world.systems"
local RX = require "libs.rx"

---@class World:Observable
local M = COMMON.class("World")

function M:reset()
	self.ecs_world:clear()
	SYSTEMS.init_systems(self.ecs_world)
end

function M:initialize()
	self.ecs_world = ECS.world()
	self.ecs_world.world = self
	self.rx = RX.Subject()
	self:reset()
end

function M:update(dt, no_save)
	self.ecs_world:update(dt)
end

function M:dispose()
	self:reset()
end

return M()