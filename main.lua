
local drawable

function love.load()
  love.window.setTitle( ' "arcade-ball" in Love2D' )
  drawable = love.graphics.newImage("ball.png")
end

local x = 150
local y = 150
local speed_x = 5
local speed_y = 5

function love.mousemoved( x, y, dx, dy )
  if love.mouse.isDown(1) then
  speed_x = speed_x + dx/2
  speed_y = speed_y + dy/2
  end
end

function love.update(dt)

  local increment_horizontal = dt*speed_x*10
  x = x + increment_horizontal

  local gravity = 1
  speed_y = speed_y + gravity

  local increment_vertical = dt*speed_y*10
  y = y + increment_vertical

  if x>400 then
    x = 400
    speed_x = speed_x * 0.7
    speed_x = - speed_x
  end

  if x<100 then
    x = 100
    speed_x = speed_x * 0.7
    speed_x = - speed_x
  end

  if y>400 then
    y = 400
    speed_y = speed_y * 0.7
    speed_y = - speed_y
  end

  if y==400 then
    speed_x = speed_x * 0.99
  end

end

function love.draw()
  love.graphics.draw( drawable, x, y, 0, 0.5, 0.5, 512/2, 512/2)
end
