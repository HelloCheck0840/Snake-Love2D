Apple = {}
Apple.__index = Apple

function Apple.new(size, color)
    local self = setmetatable({}, Apple)
    self.size = size
    self.pos = {8, 6}
    self.color = {love.math.colorFromBytes(unpack(color))}

    self.apples = {}
    return self
end

function Apple:spawn(rangex, rangey)
    self.pos = {math.random(rangex) - 1, math.random(rangey) - 1}
end

function Apple:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.pos[1] * 50 + 5, self.pos[2] * 50 + 5, self.size, self.size)
    love.graphics.setColor(1, 1, 1, 1)
end

return Apple