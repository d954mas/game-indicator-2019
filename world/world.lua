local COMMON = require "libs.common"
local ECS = require "libs.ecs"
local SYSTEMS = require "world.systems"
local RX = require "libs.rx"

---@class World:Observable
local M = COMMON.class("World")

function M:reset()
	if self.lvl then
		self.lvl:unload()
		self.lvl = nil
	end
end
---@param lvl Level
function M:set_lvl(lvl)
	assert(lvl)
	COMMON.i("LOAD LVL","[GAME]")
	self.lvl = lvl
	self.lvl:load()
end

function M:initialize()
	self.rx = RX.Subject()
	self:reset()
end

function M:update(dt, no_save)
end

function M:dispose()
	self:reset()
end

return M()