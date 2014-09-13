local Galaxy = {}

function Galaxy:init(shader)
	self.time = 0
	self.fs = love.graphics.newShader(shader)
	print(self.fs:getWarnings())
end

function Galaxy:update(dt)
	self.time = self.time + dt
	self.fs:send("iGlobalTime", self.time)
end

function Galaxy:draw(w, h)
	local x, y = love.mouse.getPosition()
	self.fs:send("offset", {x/1000.0 - 0.5, y/1000.0 - 0.5})
	
	love.graphics.setShader(self.fs)
	love.graphics.rectangle("fill", 0, 0, w, h)
	love.graphics.setShader()
end

return Galaxy
