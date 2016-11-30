game_over_state = {}

local pwnd
local newHighscore
local name = ''
local audioAbgespielt = false
local audioGameover
local audioHighscore


game_over_state.load = function()
  pwnd = love.graphics.newImage('pwnd.png')
  newHighscore = love.graphics.newImage('newhighscore.png')
  audioGameover = love.audio.newSource('sounds/GameOver2.mp3')
  audioHighscore = love.audio.newSource('sounds/Highscore.mp3')
end

game_over_state.draw = function()
  love.graphics.setColor(255, 255, 255)
  if game.getScore() > scoreboard.getHighscore() then
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
  love.graphics.print('(press return to continue)', love.graphics.getWidth()/2-80, love.graphics.getHeight()-40)
end

game_over_state.keypressed = function(key)
  if key == 'return' then
    audioAbgespielt = false
    if game.getScore() > scoreboard.getHighscore() then
      scoreboard.setHighscore(name, game.getScore())
    end
    name = ''
    audioHighscore:stop()
    audioGameover:stop()
    game.restart()
  elseif  game.getScore() > scoreboard.getHighscore() then
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
