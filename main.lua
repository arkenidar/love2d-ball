
local drawable_ball -- bouncing square image (ball)

-- calculations for update and draw
local scale = 0.25
local ball_size -- square-sized
local ball_radius

-- bounds
local x_min, x_max, y_max

-- calculations for update and draw
local border, columns_width, columns_height

function love.load()
  love.window.setTitle( ' "arcade-ball" in Love2D' )
  drawable_ball = love.graphics.newImage("ball-shiny.png") -- square-sized image

  -- calculations for update and draw
  ball_size = drawable_ball:getWidth()
  ball_radius = scale*ball_size/2

  -- bounds
  x_min = 50
  x_max = 400
  y_max = 400

  -- calculations for update and draw
  border = 10
  columns_width = x_min-border
  columns_height = y_max+ball_radius-border

end

-- ball: initial conditions
local x = 250
local y = 150
local speed_x = 5
local speed_y = 5
local ball_rotation = 0

-- input: mouse, touch also
function love.mousemoved( x, y, dx, dy )
  -- mouse drag to change speeds
  if love.mouse.isDown(1) then
  speed_x = speed_x + dx/2
  speed_y = speed_y + dy/2
  end
end

function love.update(dt)

  -- horizontal velocity
  local increment_horizontal = dt*speed_x*10
  x = x + increment_horizontal

  -- vertical: gravity and vertical velocity
  local gravity = 1
  speed_y = speed_y + gravity

  local increment_vertical = dt*speed_y*10
  y = y + increment_vertical

  -- horizontal rebounds (left and right)
  -- left rebound
  if x < ( x_min + ball_radius ) then
    x = ( x_min + ball_radius )
    speed_x = speed_x * 0.7
    speed_x = - speed_x
  end
  -- right rebound
  if x > x_max then
    x = x_max
    speed_x = speed_x * 0.7
    speed_x = - speed_x
  end

  -- vertical rebound (bottom rebound)
  if y > y_max then
    y = y_max
    speed_y = speed_y * 0.7
    speed_y = - speed_y
  end

  -- friction (horizontal)
  if y == y_max then
    speed_x = speed_x * 0.99
    ball_rotation = ball_rotation + math.pi/1024*speed_x
  end

end

function love.draw()

  -- ball (image and bounding square)
  love.graphics.draw( drawable_ball, x, y, ball_rotation, scale, scale, ball_size/2, ball_size/2)
  --love.graphics.rectangle("line", x-ball_radius,y-ball_radius, ball_radius*2, ball_radius*2)

  -- vertical columns (bounding)
  -- left column
  love.graphics.rectangle("fill", border, border, columns_width, columns_height )
  -- right column
  love.graphics.rectangle("fill", x_max+ball_radius, border, columns_width, columns_height )

  -- horizontal floor (bounding)
  love.graphics.rectangle("fill", border, columns_height+border, x_max+ball_radius+columns_width-border, columns_width)

end
