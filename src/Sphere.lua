local Sphere = {}
Sphere.__index = Sphere

function Sphere.new(r, pos)
  return setmetatable({
    r = r or 0,
    pos = pos or Vector3.new()
  }, Sphere)
end

function Sphere:ToString()	
	return "Sphere(r: " .. self.r .. ", pos: " .. self.pos:ToString() .. ")"
end

function Sphere:CheckCollision(other)
    return Vector3.Distance(self.pos, other.pos) < self.r + other.r 
end

return setmetatable({}, {__call = function(_, ...) return Sphere.new(...) end})
