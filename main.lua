
local drawable

function love.load()
  love.window.setTitle( ' "arcade-ball" in Love2D' )
  drawable = love.graphics.newImage("ball.png")
end

local x = 150
local y = 150
local speed_y = 5

function love.update(dt)
  
  local gravity = 1
  speed_y = speed_y + gravity
  
  local increment_vertical = dt*speed_y*10
  y = y + increment_vertical
  
  if y>400 then
    y = 400
    speed_y = speed_y * 0.7
    speed_y = - speed_y
  end

end

function love.draw()
  love.graphics.draw( drawable, x, y, 0, 0.5, 0.5, 512/2, 512/2)
end
