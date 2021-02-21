Vector3 = require('src.Vector3')()
Sphere  = require('src.Sphere')()
Player  = require('src.Player')()

lg = love.graphics

love.window.setMode( 800, 600, {} )
love.window.setTitle("Chocholate Defender")

local player = Player.new()
local sphere2 = Sphere.new(1, Vector3.new(5, 5, 0))

local time = 0
local collided = false
local coltime = 0

sdf = lg.newShader('shaders/sdf.glsl')
image = lg.newImage('textures/height.png')

function love.draw()
    love.graphics.setShader(sdf)
	love.graphics.rectangle("fill", 0, 0, 800, 600 )

    --[[
        love.graphics.setShader()
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
    ]]
end

function love.update(dt)
    time = time + dt

    player:Update(dt)

    --sphere2.pos:Set(time, 0, 0)

    sdf:send("iChannel1", image)
end
