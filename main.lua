_WIDTH = love.graphics.getWidth()
_HEIGHT = love.graphics.getHeight()

_SHADER = [[
	extern Image kim;

	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		vec4 red_up			= Texel(kim, texture_coords + vec2( 0.01,  0.00));
		vec4 red_down		= Texel(kim, texture_coords + vec2(-0.01,  0.00));
		vec4 red_left		= Texel(kim, texture_coords + vec2( 0.00,  0.01));
		vec4 red_right		= Texel(kim, texture_coords + vec2( 0.00, -0.01));
		vec4 red_middle		= Texel(kim, texture_coords);
		vec4 red = ((red_up + red_down + red_left + red_right + red_middle) / 5.0) + vec4(1.0, 0.0, 0.0, 1.0);

		vec4 green_up		= Texel(kim, texture_coords + vec2( 0.02,  0.00));
		vec4 green_down		= Texel(kim, texture_coords + vec2(-0.02,  0.00));
		vec4 green_left		= Texel(kim, texture_coords + vec2( 0.00,  0.02));
		vec4 green_right	= Texel(kim, texture_coords + vec2( 0.00, -0.02));
		vec4 green_middle	= Texel(kim, texture_coords);
		vec4 green = ((green_up + green_down + green_left + green_right + green_middle) / 5.0) + vec4(0.0, 1.0, 0.0, 1.0);

		vec4 blue_up		= Texel(kim, texture_coords + vec2( 0.03,  0.00));
		vec4 blue_down		= Texel(kim, texture_coords + vec2(-0.03,  0.00));
		vec4 blue_left		= Texel(kim, texture_coords + vec2( 0.00,  0.03));
		vec4 blue_right		= Texel(kim, texture_coords + vec2( 0.00, -0.03));
		vec4 blue_middle	= Texel(kim, texture_coords);
		vec4 blue = ((blue_up + blue_down + blue_left + blue_right + blue_middle) / 5.0) + vec4(0.0, 0.0, 1.0, 1.0);

		return vec4(red.r, green.g, blue.b, 1.0);
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
