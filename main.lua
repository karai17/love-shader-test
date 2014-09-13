_WIDTH	= love.graphics.getWidth()
_HEIGHT	= love.graphics.getHeight()
_TIME	= 0
_SHADER	= "galaxy.fsh"

function love.load()
	shader = love.graphics.newShader(_SHADER)
	print(shader:getWarnings())

	shader:send("iResolution", { _WIDTH, _HEIGHT })
end

function love.update(dt)
	_TIME = _TIME + dt
	shader:send("iGlobalTime", _TIME)
end

function love.draw()
        x, y = love.mouse.getPosition()
	shader:send("offset", {x/1000.0 - 0.5, y/1000.0 - 0.5})
	love.graphics.setShader(shader)
	love.graphics.rectangle("fill", 0, 0, _WIDTH, _HEIGHT)
	love.graphics.setShader()
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
