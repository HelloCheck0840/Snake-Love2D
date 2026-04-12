snake = require "player"
apple = require "apple"

local file = io.open('highscore.txt', 'r')
local highscore = file:read("n")
file:close()

if highscore == nil then
    highscore = 0
end

function love.load()
    -- Setup
    width, height = love.window.getMode()
    cell_size = 50
    rows = height / cell_size
    columns = width / cell_size
    font = love.graphics.newFont(100)

    -- Score
    score = 0

     -- Game things
    snake = snake.new(40, {5, 6}, {150, 255, 150})
    apple = apple.new(40, {255, 150, 150})
    isAlive = true

    love.window.setTitle('Snake Love2d')
end

function love.keypressed(key)
    if key == "e" then
        snake:grow()
        apple:spawn(columns, rows)
    end
    if key == "q" then
        print(unpack(apple.pos))
    end
end

function love.mousepressed(x, y, button)
    if x >= 220 and y >= height / 2 - 35 and x <= 355 + 220 and y <= 135 + height / 2 - 35 and isAlive == false and button == 1 then
        isAlive = true
        snake:reset()
        apple.pos = {8, 6}
    end
end

function collision(object)
    local object = object
    for i = 2, #snake.pieces do
        if object[1] == snake.pieces[i][1] and object[2] == snake.pieces[i][2] then
            return true
        end
    end
    return false
end

function love.update(dt)
    if not love.window.isOpen() then
        file:write(tostring(highscore))
        file:flush()
        file:close()
    end
    if isAlive then
        score = #snake.pieces - 1

        if snake.pos[1] + 1 > columns or snake.pos[2] + 1 > rows or (snake.pos[1] + 1) * (snake.pos[2] + 1) <= 0 or collision(snake.pieces[1]) then
            isAlive = false
        else
            snake:move(dt)
        end
        
        if snake.pos[1] == apple.pos[1] and snake.pos[2] == apple.pos[2] then
            repeat
                apple:spawn(columns, rows)
            until not collision(apple.pos)
            
            snake:grow()
            if score >= highscore then
                local f = io.open('highscore.txt', 'w')
                highscore = #snake.pieces - 1
                if f then
                    f:write(tostring(highscore))
                    f:close()
                end
            end
        end
    end
end

function love.draw()
    love.graphics.setFont(font)
    snake:draw()
    apple:draw()
    love.graphics.print('Score: ' .. tostring(score), 5, 5, 0, 0.25, 0.25)
    love.graphics.print('Highscore: ' .. tostring(highscore), 5, 40, 0, 0.25, 0.25)
    if isAlive == false then
        love.graphics.printf('You are dead!', 0, height / 2 - 150, width, 'center')
        love.graphics.setColor(255 / 255, 150 / 255, 150 / 255)
        love.graphics.rectangle('fill', 220, height / 2 - 35, 355, 135)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf('Retry?', 0, height / 2 - 30, width, 'center')
    end
end