_WIDTH	= love.graphics.getWidth()
_HEIGHT	= love.graphics.getHeight()

galaxy = require "galaxy"

function love.load()
	galaxy:init("galaxy.fsh")
end

function love.update(dt)
	galaxy:update(dt)
end

function love.draw()
    galaxy:draw(_WIDTH, _HEIGHT)
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
