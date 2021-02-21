local Player = {}
Player.__index = Player

function Player.new(sphere)
  return setmetatable({
    sphere = sphere or Sphere.new(1),
    health = 100
  }, Player)
end

local time = 0
local speed = 2

function Player:Update(dt)
    time = time + dt

    if love.keyboard.isDown("a") then
        self.sphere.pos.x = self.sphere.pos.x + dt * speed
    end

    if love.keyboard.isDown("d") then
        self.sphere.pos.x = self.sphere.pos.x - dt * speed
    end

    if love.keyboard.isDown("w") then
        self.sphere.pos.z = self.sphere.pos.z + dt * speed
    end

    if love.keyboard.isDown("s") then
        self.sphere.pos.z = self.sphere.pos.z - dt * speed
    end

    self.sphere.pos.y = math.sin(time * 2) * 0.02 - 0.2
end

function Player:CheckCollision(other)
    return self.sphere:CheckCollision(other)
end

function Player:ToString()	
	return "Player(health: " .. self.health .. ", r: " .. self.sphere.r .. ", pos: " .. self.sphere.pos:ToString() .. ")"
end

return setmetatable({}, {__call = function(_, ...) return Player.new(...) end})