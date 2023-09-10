
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
  x_max = 400
  y_max = 400

  -- calculations for update and draw
  border = 10
  columns_width = 30
  x_min = border+columns_width+ball_radius
  columns_height = y_max+ball_radius-border

end

-- ball: initial conditions
local x = 250
local y = 150
local speed_x = 5
local speed_y = 5
local ball_rotation = 0
local ball_rotation_speed = 0
local attenuation = 0.99

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
  if x < x_min then
    x = x_min
    speed_x = speed_x * 0.6
    speed_x = - speed_x
  end
  -- right rebound
  if x > x_max then
    x = x_max
    speed_x = speed_x * 0.6
    speed_x = - speed_x
  end

  -- vertical rebound (bottom rebound)
  if y > y_max then
    y = y_max
    speed_y = speed_y * 0.6
    speed_y = - speed_y
  end

  -- for angular speed (translation to rotation)
  local ball_angle = math.pi/32

  -- friction (bottom, horizontal)
  if y == y_max then
    speed_x = speed_x * attenuation
    ball_rotation_speed = ball_angle*speed_x
  end

  -- friction (left, vertical)
  if x == x_min then
    speed_y = speed_y * attenuation
    ball_rotation_speed = ball_angle*speed_y
  end

  -- friction (right, vertical)
  if x == x_max then
    speed_y = speed_y * attenuation
    ball_rotation_speed = -ball_angle*speed_y
  end

  -- ball rotation
  ball_rotation_speed = ball_rotation_speed * attenuation
  ball_rotation = ball_rotation + dt*ball_rotation_speed

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
