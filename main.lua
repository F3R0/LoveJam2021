Vector3 = require('src.Vector3')()
Sphere  = require('src.Sphere')()
Player  = require('src.Player')()

lg = love.graphics

love.window.setMode( 800, 600, {} )
love.window.setTitle("Chocholate Defender")

local player = Player.new(Sphere.new(0.3, Vector3.new(0, 0, 5)))
local sphere = Sphere.new(1, Vector3.new(0, 5, 5))

local sndSlurp = love.audio.newSource("snd/slurp.wav", "static")

local time = 0
local collided = false
local score = 0
local lerpProgress = 0
local isMenu = true
local health = 5

sdf = lg.newShader('shaders/sdf.glsl')
menu = lg.newShader('shaders/menu.glsl')
image = lg.newImage('textures/height.png')
image:setWrap("repeat")

function love.draw()
    if isMenu then
        love.graphics.setShader(menu)
        love.graphics.rectangle("fill", 0, 0, 800, 600 )
        love.graphics.setShader()
        lg.print("Star Game: " .. score, 10, 10)
        lg.print("Credits: " .. health, 10, 22)
        
    else
        love.graphics.setShader(sdf)
        love.graphics.rectangle("fill", 0, 0, 800, 600 )

        love.graphics.setShader()
        --lg.print("Score: " .. player.sphere.pos.x, 10, 10)
        --lg.print("Health: " .. player.sphere.pos.z, 10, 22)
    end
end

function love.update(dt)
    
    time = time + dt
    
    if isMenu then
        if love.keyboard.isDown("return") then
            isMenu = false
        end

        menu:send("iTime", time)
        menu:send("iChannel1", image)

    else
        
    
        player:Update(dt)
    
        sphere.pos.y = sphere.pos.y - dt

        if health == 0 then 
            isMenu = true
        end

        if not collided then
            sphere.pos.y = sphere.pos.y - dt
            collided = player:CheckCollision(sphere)
        elseif collided and lerpProgress < 1 then
            if lerpProgress == 0 then
                love.audio.play(sndSlurp)
            end

            lerpProgress = lerpProgress + dt
            
            target = player.sphere.pos:Clone()
            target.y = sphere.pos.y
    
            sphere.pos:LerpTo(target, lerpProgress)
        end
    
        if sphere.pos.y <= -2 then
            lerpProgress = 0
    
            if collided then
                score = score + 1
            else
                health = health - 1
            end
            
            sphere.pos:Set(math.random(-2, 3.5), 5, math.random(2.5, 8.5))
            collided = false
        end
    
        sdf:send("iChannel1", image)
        sdf:send("player", {player.sphere.pos.x, player.sphere.pos.y, player.sphere.pos.z, player.sphere.r})
        sdf:send("sphere", {sphere.pos.x, sphere.pos.y, sphere.pos.z, sphere.r / 10})
    end        
end
