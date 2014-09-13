_WIDTH = love.graphics.getWidth()
_HEIGHT = love.graphics.getHeight()
_SHADER = "galaxy.fs"

function love.load()
	shader = love.graphics.newShader(_SHADER)
	print(shader:getWarnings())
end

function love.draw()
	love.graphics.setShader(shader)
	love.graphics.rectangle("fill", 0, 0, _WIDTH, _HEIGHT)
	love.graphics.setShader()
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
