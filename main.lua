Vector3 = require('src.Vector3')()
Sphere  = require('src.Sphere')()
Player  = require('src.Player')()

lg = love.graphics

love.window.setMode( 800, 600, {} )
love.window.setTitle("Chocholate Defender")

local player = Player.new(Sphere.new(0.3, Vector3.new(0, 0, 5)))
local sphere = Sphere.new(0.2, Vector3.new(0, 5, 5))

local time = 0
local collided = false
local score = 0
local lerpProgress = 0

sdf = lg.newShader('shaders/sdf.glsl')
image = lg.newImage('textures/height.png')
image:setWrap("repeat")

function love.draw()
    love.graphics.setShader(sdf)
	love.graphics.rectangle("fill", 0, 0, 800, 600 )

    love.graphics.setShader()
    lg.print("Score: " .. score, 10, 10)
end

function love.update(dt)
    time = time + dt

    player:Update(dt)

    if not collided then
        collided = player:CheckCollision(sphere)
    end

    if collided then
        lerpProgress = lerpProgress + dt / 5
        local target = player.sphere.pos:Clone()
        target.y = -3
        sphere.pos:LerpTo(target, lerpProgress)
    else
        sphere.pos.y = sphere.pos.y - dt
    end

    if sphere.pos.y < -2 then
        lerpProgress = 0

        if collided then
            score = score + 1
        end
        
        sphere.pos:Set(math.random(-2, 2), 5, math.random(3, 7))
        collided = false
    end

    sdf:send("iChannel1", image)
    sdf:send("player", {player.sphere.pos.x, player.sphere.pos.y, player.sphere.pos.z, player.sphere.r})
    sdf:send("sphere", {sphere.pos.x, sphere.pos.y, sphere.pos.z, sphere.r / 2})
end
