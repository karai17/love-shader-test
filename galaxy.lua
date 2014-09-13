local Galaxy = {}

function Galaxy:init(shader, quality)
   self.time = 0
   local source = love.filesystem.read(shader)
   if quality == "insane" then
      source = source:gsub("$FRONT_LAYER_QUALITY", "300")
      source = source:gsub("$BACK_LAYER_QUALITY", "150")
      
      source = source:gsub("$FRONT_LAYER_INTENSITY", "10000.0")
      source = source:gsub("$BACK_LAYER_INTENSITY", "20000.0")

      source = source:gsub("$DEFINE_EVOLVE", "#define EVOLVE")
   elseif quality == "high" then
      source = source:gsub("$FRONT_LAYER_QUALITY", "80")
      source = source:gsub("$BACK_LAYER_QUALITY", "40")
      
      source = source:gsub("$FRONT_LAYER_INTENSITY", "5000.0")
      source = source:gsub("$BACK_LAYER_INTENSITY", "8000.0")

      source = source:gsub("$DEFINE_EVOLVE", "#define EVOLVE")
   elseif quality == "medium" then
      source = source:gsub("$FRONT_LAYER_QUALITY", "26")
      source = source:gsub("$BACK_LAYER_QUALITY", "18")

      source = source:gsub("$FRONT_LAYER_INTENSITY", "10000.0")
      source = source:gsub("$BACK_LAYER_INTENSITY", "15000.0")

      source = source:gsub("$DEFINE_EVOLVE", "#define EVOLVE")
   elseif quality == "low" then
      source = source:gsub("$FRONT_LAYER_QUALITY", "20")
      source = source:gsub("$BACK_LAYER_QUALITY", "10")

      source = source:gsub("$FRONT_LAYER_INTENSITY", "20000.0")
      source = source:gsub("$BACK_LAYER_INTENSITY", "30000.0")

      source = source:gsub("$DEFINE_EVOLVE", "")
   end
   print(source)
   self.fs = love.graphics.newShader(source)
   self.frequencies = {0.5, 0.5, 0.5, 0.5}
   print(self.fs:getWarnings())
end

function Galaxy:update(dt)
   -- make channels fade out
   for i in ipairs(self.frequencies) do
      self.frequencies[i] = self.frequencies[i] - 0.3*dt;

   end
   if math.random(0, 100)*dt < 0.2 then
      local which = math.random(1, 4)
      self.frequencies[which] = self.frequencies[which] + 0.1
   end
   for i in ipairs(self.frequencies) do
      self.frequencies[i] = math.clamp(0.1, self.frequencies[i], 10.0)
   end
   self.time = self.time + dt
end

function Galaxy:draw(w, h)
   local x, y = love.mouse.getPosition()
   self.fs:send("offset", {x/1000.0 - 0.5, y/1000.0 - 0.5})
   self.fs:send("freqs", self.frequencies)
   self.fs:send("global_time", self.time)
   self.fs:send("global_time_sin", math.sin(self.time))

   
   love.graphics.setShader(self.fs)
   love.graphics.rectangle("fill", 0, 0, w, h)
   love.graphics.setShader()
end

-- Clamps a number to within a certain range.
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end

return Galaxy
