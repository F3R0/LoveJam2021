Vector3 = require('src.Vector3')()
Sphere  = require('src.Sphere')()
Player  = require('src.Player')()

lg = love.graphics

love.window.setTitle("Chocholate Defender")

local player = Player.new()
local sphere2 = Sphere.new(1, Vector3.new(5, 5, 0))

local time = 0
local collided = false
local coltime = 0

function love.load()

end

function love.draw()
    if not collided then
        collided = player:CheckCollision(sphere2)

        if collided then
            coltime = time
        end
    end

    lg.print("Time: " .. math.floor(time * 100) / 100, 0, 0)
    lg.print("Collision: " .. tostring(collided), 0, 12)
    lg.print("Collision Time: " .. coltime, 0, 24)

    --

    lg.print("Player: " .. player:ToString(), 0, 40)
    lg.print("Sphere 2: " .. sphere2:ToString(), 0, 52)
end

function love.update(dt)
    time = time + dt

    player:Update(dt)

    --sphere2.pos:Set(time, 0, 0)
end
