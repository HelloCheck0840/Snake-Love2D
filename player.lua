local Player = {}
Player.__index = Player

function Player.new(size, pos, color)
    local self = setmetatable({}, Player)
    self.size = size
    self.color = {love.math.colorFromBytes(unpack(color))}

    self.spawn = {pos[1], pos[2]}
    self.pieces = {pos}
    self.pos = self.pieces[1]
    self.old = {0, 0}

    self.movement = {0, 0}
    self.movequeue = {0, 0}

    self.timer = 0
    self.delay = 0.25
    
    return self
end

function Player:move(dt)
    if love.keyboard.isDown('w') and self.movement[2] == 0 then self.movequeue = { 0, -1} end
    if love.keyboard.isDown('a') and self.movement[1] == 0 then self.movequeue = {-1, 0} end
    if love.keyboard.isDown('s') and self.movement[2] == 0 then self.movequeue = {0, 1} end
    if love.keyboard.isDown('d') and self.movement[1] == 0 then self.movequeue = {1, 0} end
    
    self.timer = self.timer + dt
    if self.timer >= self.delay then
        self.old = {self.pos[1], self.pos[2]}
        self.movement = self.movequeue

        self.pieces[#self.pieces][1] = self.pieces[1][1] + self.movement[1]
        self.pieces[#self.pieces][2] = self.pieces[1][2] + self.movement[2]
        if #self.pieces > 1 then
            table.insert(self.pieces, 1, self.pieces[#self.pieces])
            table.remove(self.pieces, #self.pieces)
        end

        self.pos = self.pieces[1]
        self.timer = 0
    end
end

function Player:grow()
    table.insert(self.pieces, self.old)
end

function Player:reset()
    self.pieces = {{self.spawn[1], self.spawn[2]}}
    print(unpack(self.pieces[1]))
    self.pos = self.pieces[1]
    self.old = {0, 0}

    self.movement = {0, 0}
    self.movequeue = {0, 0}
end

function Player:draw()
    love.graphics.setColor(self.color)
    for _, i in ipairs(self.pieces) do
        love.graphics.rectangle('fill', i[1] * 50 + 5, i[2] * 50 + 5, self.size, self.size)
    end
    love.graphics.setColor(1, 1, 1)
end

return Player