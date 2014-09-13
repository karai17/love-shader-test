local Galaxy = {}

function Galaxy:init(shader)
   self.time = 0
   self.fs = love.graphics.newShader(shader)
   self.frequencies = {0.5, 0.5, 0.5, 0.5}
   print(self.fs:getWarnings())
end

function Galaxy:update(dt)
   -- make channels fade out
   for i in ipairs(self.frequencies) do
      self.frequencies[i] = self.frequencies[i] - 0.6*dt;

   end
   if math.random(0, 100)*dt < 0.2 then
      local which = math.random(1, 4)
      self.frequencies[which] = self.frequencies[which] + 0.1
   end
   for i in ipairs(self.frequencies) do
      self.frequencies[i] = math.clamp(0.1, self.frequencies[i], 1.0)
   end
   self.time = self.time + dt
end

function Galaxy:draw(w, h)
   local x, y = love.mouse.getPosition()
   self.fs:send("offset", {x/1000.0 - 0.5, y/1000.0 - 0.5})
   self.fs:send("freqs", self.frequencies)
   self.fs:send("iGlobalTime", self.time)

   
   love.graphics.setShader(self.fs)
   love.graphics.rectangle("fill", 0, 0, w, h)
   love.graphics.setShader()
end

-- Clamps a number to within a certain range.
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end

return Galaxy
