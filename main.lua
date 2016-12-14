savegame = require("./savegame")
game = require('./game')
game_over_state = require('./game_over_state')
coins = require('./coins')
main_menu = require('./main_menu')

local persisted_state = savegame.load()
current_state = main_menu

local function new_high_score(name, new_score)
    persisted_state = savegame.add_score(persisted_state, name, new_score)
    savegame.save(persisted_state)
    return persisted_state
end

function love.load()
  love.window.setTitle('Woodman')
  love.graphics.setBackgroundColor(255, 255, 255)
  normalFont = love.graphics.newFont(12)
  semiLargeFont = love.graphics.newFont(22)
  largeFont = love.graphics.newFont(40)
  love.graphics.setFont(normalFont)

  game_over_state.load(new_high_score, persisted_state)
  game.load(new_high_score, persisted_state)
  coins.load(persisted_state)
  main_menu.load()

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
