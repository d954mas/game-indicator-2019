local COMMON = require "libs.common"

local Matcher = COMMON.class("matcher")

function Matcher:initialize()
    self.free = 0
    self.fill = 0
    self.start_free = 0
    self.percent = 0
end

function Matcher:init_buffer()
end

function Matcher:make_dirty()
  
end

function Matcher:enable_draw()
end

function Matcher:disable_draw()
end

function Matcher:start_lvl()
    self.buffer, self.w, self.h = screenshot.buffer()
    local buffer_info = {
        buffer = self.buffer,
        width = self.w,
        height = self.h,
        channels = 4
    }
    self.free, self.fill = drawpixels.check_fill(buffer_info)
    self.start_free = self.free + self.fill
end

function  Matcher:update_texture()
    if self.start_free == 0 then return end --wait initial check
    --update test texture
    self.buffer, self.w, self.h = screenshot.buffer()
    local buffer_info = {
        buffer = self.buffer,
        width = self.w,
        height = self.h,
        channels = 4
    }
    local free, fill = drawpixels.check_fill(buffer_info)
    self.fill = fill
    self.free = free
    self.percent = self.fill/self.start_free
end    

return Matcher()