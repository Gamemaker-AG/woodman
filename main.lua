savegame = require("./savegame")
game = require('./game')
game_over_state = require('./game_over_state')
local persisted_state = savegame.load()

local function new_high_score(name, new_score)
    persisted_state = savegame.add_score(persisted_state, name, new_score)
    savegame.save(persisted_state)
    return persisted_state
end

function love.load()
  love.window.setTitle('Woodman')
  love.graphics.setBackgroundColor(255, 255, 255)
  normalFont = love.graphics.newFont(12)
  largeFont = love.graphics.newFont(40)
  love.graphics.setFont(normalFont)

  game_over_state.load(new_high_score, persisted_state)
  game.load(new_high_score, persisted_state)

  highscore_name = '';

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
