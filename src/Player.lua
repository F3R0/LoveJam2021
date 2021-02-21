local Player = {}
Player.__index = Player

function Player.new(sphere)
  return setmetatable({
    sphere = sphere or Sphere.new(1),
    health = 100
  }, Player)
end

function Player:Update(dt)
    if love.keyboard.isDown("d") then
        self.sphere.pos.x = self.sphere.pos.x + dt
    end

    if love.keyboard.isDown("a") then
        self.sphere.pos.x = self.sphere.pos.x - dt
    end

    if love.keyboard.isDown("w") then
        self.sphere.pos.y = self.sphere.pos.y + dt
    end

    if love.keyboard.isDown("s") then
        self.sphere.pos.y = self.sphere.pos.y - dt
    end
end

function Player:CheckCollision(other)
    return self.sphere:CheckCollision(other)
end

function Player:ToString()	
	return "Player(health: " .. self.health .. ", r: " .. self.sphere.r .. ", pos: " .. self.sphere.pos:ToString() .. ")"
end

return setmetatable({}, {__call = function(_, ...) return Player.new(...) end})