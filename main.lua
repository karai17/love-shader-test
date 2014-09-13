_WIDTH = love.graphics.getWidth()
_HEIGHT = love.graphics.getHeight()

_SHADER = [[
	extern Image kim;

	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		vec4 left	= Texel(kim, texture_coords - vec2( 0.05,  0.0));
		vec4 right	= Texel(kim, texture_coords + vec2( 0.05,  0.0));
		vec4 pixel	= Texel(kim, texture_coords);

		return vec4(left.r, pixel.g, right.b, (left.a + 3*pixel.a + right.a)/5);
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
	love.graphics.setShader(shader)
	love.graphics.draw(osama, quad, _WIDTH / 2 - 25, _HEIGHT / 2 - 25)
	love.graphics.setShader()
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
