_WIDTH = love.graphics.getWidth()
_HEIGHT = love.graphics.getHeight()

_SHADER = [[
	extern Image kim;

	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		return Texel(kim, texture_coords);
	}
]]

function love.load()
	shader = love.graphics.newShader(_SHADER)
	print(shader:getWarnings())

	shader:send("kim", love.graphics.newImage("kim.png"))
end

function love.update(dt)

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
