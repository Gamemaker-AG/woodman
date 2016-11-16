game = {}

local man
local man2
local log_blank
local log_right
local flying_logs

game.load = function()
  man = love.graphics.newImage('man.png')
  man2 = love.graphics.newImage('man2.png')
  log_blank = love.graphics.newImage('tree2.png')
  log_right = love.graphics.newImage('tree.png')
end

game.update = function(delta_time)
  chop_timer = chop_timer + delta_time
  death_timer = death_timer - delta_time

  if death_timer <= 0 then
    show_game_over_state()
  end

  for index, flying_log in ipairs(flying_logs) do
    flying_log.timer = flying_log.timer + delta_time
    if flying_log.timer > 0.3 then
      table.remove(flying_logs, index)
    end
  end
end

game.keypressed = function(key)
  if key == 'right' then
    position = 'right'
    chop()
  elseif key == 'left' then
    position = 'left'
    chop()
  end
end

game.draw = function()
  man_image = man2

  if chop_timer < 0.1 then
    man_image = man
  end

  if position == 'right' then
    man_x = 700
    scale_x = 1
  else
    man_x = 100
    scale_x = -1
  end

  love.graphics.draw(
    man_image,
    man_x, 300,
    0,
    scale_x, 1,
    man:getWidth()/2, 0
  )

  for index, direction in ipairs(logs) do
    log_image = log_blank
    scale_x = 1
    if direction == 'right' then
      log_image = log_right
    elseif direction == 'left' then
      log_image = log_right
      scale_x = -1
    end
    love.graphics.draw(
      log_image,
      400, 600 - (index * log_image:getHeight()),
      0,
      scale_x, 1,
      log_image:getWidth()/2, 0
    )
  end

  for index, flying_log in ipairs(flying_logs) do
    local log_image = log_blank
    local scale_x = 1
    if flying_log.type == 'right' then
      log_image = log_right
    elseif flying_log.type == 'left' then
      log_image = log_right
      scale_x = -1
    end

    local flying_direction = 1

    if flying_log.direction == 'left' then
      flying_direction = -1
    end

    local position_x = 400 + (flying_log.timer * 100 * flying_direction)
    love.graphics.setColor(255, 255, 255, (255 * (1 - flying_log.timer /0.3)))

    love.graphics.draw(log_image, position_x, 400, 0, scale_x, 1, log_right:getWidth()/2, 0)
  end

  love.graphics.setColor(0, 0, 0)
  love.graphics.print(score, 50, 50)

  love.graphics.rectangle('line', 100, 50, 100 * (death_timer/10), 20)
end

function chop()
  if logs[1] == position or logs[2] == position then
    show_game_over_state()
  else
    chop_timer = 0
    score = score + 1
    death_timer = math.min(death_timer + (1/score), 10)
    generate_log()
    table.insert(flying_logs, {
      timer = 0,
      type = logs[1],
      direction = (position == "right" and "left" or "right")
    })
    table.remove(logs, 1)
  end
end

function generate_log()
  if logs[#logs] == 'blank' then
    if logs[#logs-1] == 'right' then
      table.insert(logs, 'left')
    else
      table.insert(logs, 'right')
    end
  else
    if love.math.random() < 0.5 then
      table.insert(logs, 'blank')
    else
      table.insert(logs, logs[#logs])
    end
  end
end

function show_game_over_state()
  game_over = true
  game_over_state.restart(score)
end

game.restart = function()
  score = 0
  logs = { 'blank' }
  flying_logs = {}
  chop_timer = 0
  position = 'right'
  death_timer = 10
  game_over = false

  for i = 1, 4, 1 do
    generate_log()
  end
end

return game
