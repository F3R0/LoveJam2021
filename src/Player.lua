local Player = {}
Player.__index = Player

function Player.new(sphere)
  return setmetatable({
    sphere = sphere or Sphere.new(1),
    jumpHeight = 3,
    isGrounded = true
  }, Player)
end

local time = 0
local speed = 2
local velocity = 0
local gravity = 10

function Player:Update(dt)

    time = time + dt
 
    -- Movement

    if love.keyboard.isDown("a") and self.sphere.pos.x < 4 then
        self.sphere.pos.x = self.sphere.pos.x + dt * speed
    end

    if love.keyboard.isDown("d") and self.sphere.pos.x > -4 then
        self.sphere.pos.x = self.sphere.pos.x - dt * speed
    end

    if love.keyboard.isDown("w") and self.sphere.pos.z < 9 then
        self.sphere.pos.z = self.sphere.pos.z + dt * speed
    end

    if love.keyboard.isDown("s") and self.sphere.pos.z > 1 then
        self.sphere.pos.z = self.sphere.pos.z - dt * speed
    end

    -- Jumping

    if love.keyboard.isDown("space") and self.isGrounded then
        self.isGrounded = false
        velocity = self.jumpHeight
    end

    if not self.isGrounded then
        self.sphere.pos.y = self.sphere.pos.y + velocity * dt
        velocity = velocity - gravity * dt
    end

    if self.sphere.pos.y < 0 then
        self.isGrounded = true
        self.sphere.pos.y = 0
    end
end 

function Player:CheckCollision(other)
    return self.sphere:CheckCollision(other)
end

function Player:ToString()	
	return "Player(health: " .. self.health .. ", r: " .. self.sphere.r .. ", pos: " .. self.sphere.pos:ToString() .. ")"
end

return setmetatable({}, {__call = function(_, ...) return Player.new(...) end})