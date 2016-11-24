game = require('./game')
game_over_state = require('./game_over_state')

function love.load()
  love.graphics.setBackgroundColor(255, 255, 255)

  game_over_state.load()
  game.load()

  game.restart()
end

function love.update(delta_time)

  if not game_over then
    game.update(delta_time)
  end
end

function love.draw()
  if game_over then
    game_over_state.draw()
  else
    game.draw()
  end
end

function love.keypressed(key)
  if key == "escape" then
    os.exit()
  elseif not game_over then
    game.keypressed(key)
  else
    game_over_state.keypressed(key)
  end
end
