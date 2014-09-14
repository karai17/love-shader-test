local Galaxy = {}

function Galaxy:init(shader, quality)
   self.time = 0
   local source = love.filesystem.read(shader)

   self.quality = {}
   self.quality.insane  = source:gsub("$FRONT_LAYER_QUALITY", "300")
   self.quality.insane  = self.quality.insane:gsub("$BACK_LAYER_QUALITY", "150")
   self.quality.insane  = self.quality.insane:gsub("$FRONT_LAYER_INTENSITY", "10000.0")
   self.quality.insane  = self.quality.insane:gsub("$BACK_LAYER_INTENSITY", "20000.0")
   self.quality.insane  = self.quality.insane:gsub("$DEFINE_EVOLVE", "#define EVOLVE")

   self.quality.high    = source:gsub("$FRONT_LAYER_QUALITY", "80")
   self.quality.high    = self.quality.high:gsub("$BACK_LAYER_QUALITY", "40")
   self.quality.high    = self.quality.high:gsub("$FRONT_LAYER_INTENSITY", "5000.0")
   self.quality.high    = self.quality.high:gsub("$BACK_LAYER_INTENSITY", "8000.0")
   self.quality.high    = self.quality.high:gsub("$DEFINE_EVOLVE", "#define EVOLVE")

   self.quality.medium  = source:gsub("$FRONT_LAYER_QUALITY", "26")
   self.quality.medium  = self.quality.medium:gsub("$BACK_LAYER_QUALITY", "18")
   self.quality.medium  = self.quality.medium:gsub("$FRONT_LAYER_INTENSITY", "10000.0")
   self.quality.medium  = self.quality.medium:gsub("$BACK_LAYER_INTENSITY", "15000.0")
   self.quality.medium  = self.quality.medium:gsub("$DEFINE_EVOLVE", "#define EVOLVE")

   self.quality.low     = source:gsub("$FRONT_LAYER_QUALITY", "20")
   self.quality.low     = self.quality.low:gsub("$BACK_LAYER_QUALITY", "10")
   self.quality.low     = self.quality.low:gsub("$FRONT_LAYER_INTENSITY", "20000.0")
   self.quality.low     = self.quality.low:gsub("$BACK_LAYER_INTENSITY", "30000.0")
   self.quality.low     = self.quality.low:gsub("$DEFINE_EVOLVE", "")

   self.fs = love.graphics.newShader(self.quality[quality])
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
   -- half-assed attempt at motion. some sort of randomized pathing would be cool!
   local x, y = math.sin(self.time / 16), math.cos(self.time / 12)
   self.fs:send("offset", { x, y })
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
