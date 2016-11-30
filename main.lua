scoreboard = require('./scoreboard')
game = require('./game')
game_over_state = require('./game_over_state')
current_state = game

function love.load()
  love.window.setTitle('Woodman')
  love.graphics.setBackgroundColor(255, 255, 255)
  normalFont = love.graphics.newFont(12)
  largeFont = love.graphics.newFont(40)
  love.graphics.setFont(normalFont)

  game_over_state.load()
  game.load()

  highscore_name = '';

  game.restart()
end

function love.update(delta_time)
  if current_state.update then
    current_state.update(delta_time)
  end
end

function love.draw()
  if current_state.draw then
    current_state.draw()
  end
end

function love.keypressed(key)
  if key == "escape" then
    os.exit()
  elseif current_state.keypressed then
    current_state.keypressed(key)
  end
end
