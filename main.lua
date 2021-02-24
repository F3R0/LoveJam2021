Vector3 = require('src.Vector3')()
Sphere  = require('src.Sphere')()
Player  = require('src.Player')()

lg = love.graphics

love.window.setMode( 800, 600, {} )
love.window.setTitle("Chocolate Defender")

local player = Player.new(Sphere.new(0.3, Vector3.new(0, 0, 5)))
local sphere = Sphere.new(1, Vector3.new(0, 5, 5))

local sndSlurp = love.audio.newSource("snd/slurp.wav", "static")
sndSlurp:setVolume(0.3)

local music = love.audio.newSource("snd/raymarch.mp3", "static")
music = love.audio.newSource("snd/raymarch.mp3", "static")
music:setLooping(true)
music:setVolume(0.1)
music:play() 

local font = love.graphics.newFont("fonts/Akaya.ttf", 32);
local font2 = love.graphics.newFont("fonts/Akaya.ttf", 48);
local font3 = love.graphics.newFont("fonts/Akaya.ttf", 20);

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
        lg.print("Chocolate Defender", font2, 10, 10)
        lg.print("press [ENTER] to start", font, 10, 200)
        lg.print("WASD - Move\nSpace - Jump", font3, 10, 300)
        lg.print("Ferhat Tanman \nSercan Altundas", font, 10, 450)
        lg.print("soundimage.org | freesound.org | fonts.google.com", font3, 10, 560)
    else
        love.graphics.setShader(sdf)
        love.graphics.rectangle("fill", 0, 0, 800, 600 )

        love.graphics.setShader()
        lg.print("Health: " .. health, font,  10, 10)
        lg.print("Score: " .. score, font, 660, 10)
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
            health = 5
            score = 0
            sphere.pos:Set(0, 5, 0)
            collided = false
            player.sphere.pos:Set(0, 0, 5)
            lerpProgress = 0 
            time = 0
        end

        if not collided then
            sphere.pos.y = sphere.pos.y - dt
            collided = player:CheckCollision(sphere)
        elseif collided and lerpProgress < 1 then
            if lerpProgress == 0 then
                score = score + 1
                love.audio.play(sndSlurp)
            end

            lerpProgress = lerpProgress + dt
            
            target = player.sphere.pos:Clone()
            target.y = sphere.pos.y
    
            sphere.pos:LerpTo(target, lerpProgress)
        end
    
        if sphere.pos.y <= -2 then
            lerpProgress = 0
    
            if not collided then
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