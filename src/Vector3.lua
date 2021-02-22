local Vector3 = {}
Vector3.__index = Vector3

function Vector3.new(x, y, z)
  return setmetatable({
    x = x or 0,
    y = y or 0,
    z = z or 0
  }, Vector3)
end

function Vector3:Set(x, y, z)	
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

function Vector3:ToString()	
	return "Vector3(" .. math.floor(self.x * 100) / 100 .. ", " .. math.floor(self.y * 100) / 100 .. ", " .. math.floor(self.z * 100) / 100 .. ")"
end 

function Vector3:Clone()
	return Vector3.new(self.x, self.y, self.z)
end

function Vector3.Distance(a, b)
	return math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2 + (a.z - b.z)^2)
end

function Vector3:LerpTo(to, t)	
  	t = math.min(math.max(t, 0), 1)
	self:Set(self.x + ((to.x - self.x) * t), self.y + ((to.y - self.y) * t), self.z + ((to.z - self.z) * t))
end

return setmetatable({}, {__call = function(_, ...) return Vector3.new(...) end})
