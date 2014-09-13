_WIDTH = love.graphics.getWidth()
_HEIGHT = love.graphics.getHeight()

_SHADER = [[
	extern vec4 green;
	extern vec4 mouse;

	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		return vec4(mouse.r, green.g, mouse.b, mouse.a);
	}
]]

function love.load()
	shader = love.graphics.newShader(_SHADER)
	shader:send("green", { 0.0, 1.0, 0.0, 1.0 })

	print(shader:getWarnings())

end

function love.update(dt)
	local x, y = love.mouse.getPosition()
	x = x / _WIDTH
	y = y / _HEIGHT
	shader:send("mouse", { x, 0.0, y, 1.0 })

end

function love.draw()
	love.graphics.setColor(255, 255, 0, 255)
	love.graphics.rectangle("fill", 0, 0, _WIDTH, _HEIGHT)

	love.graphics.setShader(shader)
	love.graphics.rectangle("fill", 50, 50, _WIDTH-100, _HEIGHT-100)
	love.graphics.setShader()
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
