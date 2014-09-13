_WIDTH = love.graphics.getWidth()
_HEIGHT = love.graphics.getHeight()

_SHADER = [[
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		return vec4(1.0, 0.0, 0.0, 1.0);
	}
]]

function love.load()
	shader = love.graphics.newShader(_SHADER)
end

function love.update(dt)

end

function love.draw()
	love.graphics.setColor(255, 255, 0, 255)
	love.graphics.rectangle("fill", 0, 0, _WIDTH, _HEIGHT)
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
