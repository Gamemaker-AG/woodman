local savegame = require("savegame")
game_over_state = {}

local pwnd
local newHighscore
local name = ''
local audioAbgespielt = false
local audioGameover
local audioHighscore
local coinsInvestieren
local new_score_callback
local persisted_state

game_over_state.load = function(callback, state)
  new_score_callback = callback
  persisted_state = state
  pwnd = love.graphics.newImage('img/pwnd.png')
  newHighscore = love.graphics.newImage('img/newhighscore.png')
  coinsInvestieren = love.graphics.newImage('img/coins.png')
  audioGameover = love.audio.newSource('sounds/GameOver2.mp3')
  audioHighscore = love.audio.newSource('sounds/Highscore.mp3')
end

game_over_state.draw = function()
  love.graphics.setColor(255, 255, 255)
  if game.getScore() > savegame.getHighscore(persisted_state) then
    love.graphics.draw(newHighscore, 0, 0)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(largeFont)
    love.graphics.print('You scored ' .. game.getScore() .. '!', love.graphics.getWidth()/2-150, love.graphics.getHeight()-200)
    love.graphics.print('Name: ' .. name, love.graphics.getWidth()/2-150, love.graphics.getHeight()-120)
    love.graphics.setFont(normalFont)
    if not audioAbgespielt then
      audioHighscore:play()
      audioAbgespielt = true
    end
  else
    love.graphics.draw(pwnd, 0, 0)
    love.graphics.setColor(0, 0, 0)
    if not audioAbgespielt then
      audioGameover:play()
      audioAbgespielt = true
    end
  end
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(coinsInvestieren, 530, 550)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print('(press return to continue)', love.graphics.getWidth()/2-80, love.graphics.getHeight()-40)
end

game_over_state.keypressed = function(key)
  if key == 'return' then
    audioAbgespielt = false
    if game.getScore() > savegame.getHighscore(persisted_state) then
      new_score_callback(name, game.getScore())
      savegame.save(persisted_state)
    end
    name = ''
    audioHighscore:stop()
    audioGameover:stop()
    game.restart()
    current_state = game
  elseif key == 'tab' then
    current_state = coins
    coins.update_state(persisted_state)
  elseif  game.getScore() > savegame.getHighscore(persisted_state) then
    if key == 'backspace' then
      name = string.sub(name, 1, #name - 1)
    elseif key == 'space' then
      name = name .. ' '
    elseif key == string.match(key, '%w?-?') then
      if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
        key = string.upper(key)
      end
      name = name .. key
    end
  end
end

return game_over_state
