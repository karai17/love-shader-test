_WIDTH = love.graphics.getWidth()
_HEIGHT = love.graphics.getHeight()

_SHADER = [[
	extern Image kim;
	extern vec2 blur;

	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		vec4 up		= Texel(kim, texture_coords + vec2( blur.x, 0.0));
		vec4 down	= Texel(kim, texture_coords + vec2(-blur.x, 0.0));
		vec4 left	= Texel(kim, texture_coords + vec2(0.0,  blur.y));
		vec4 right	= Texel(kim, texture_coords + vec2(0.0, -blur.y));
		vec4 middle	= Texel(kim, texture_coords);

		return (up + down + left + right + middle) / 4.0;
	}
]]

function love.load()
	shader = love.graphics.newShader(_SHADER)
	print(shader:getWarnings())
	shader:send("kim", love.graphics.newImage("kim.png"))

	osama = love.graphics.newImage("osama.png")
	quad = love.graphics.newQuad(0, 0, 50, 50, osama:getDimensions())
end

function love.update(dt)

end

function love.draw()
	local x, y = love.mouse.getPosition()
	local x = x / _WIDTH / 2.0
	local y = y / _HEIGHT / 2.0

	shader:send("blur", {x, y})
	love.graphics.setShader(shader)
	love.graphics.draw(osama, quad, _WIDTH / 2 - 25, _HEIGHT / 2 - 25)
	love.graphics.setShader()
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
