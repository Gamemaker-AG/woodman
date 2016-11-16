game_over_state = {}

local pwnd
local highscore = 0
local last_score

game_over_state.restart = function(current_score)
  last_score = current_score
  if current_score > highscore then
    highscore = current_score
  end
end

game_over_state.load = function()
  pwnd = love.graphics.newImage('pwnd.png')
end

game_over_state.draw = function()
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(pwnd, 0, 0)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print('You scored ' .. last_score, 50, 50)
  love.graphics.print('Highscore is ' .. highscore, 50, 75)
end

game_over_state.keypressed = function(key)
  if key == "space" then
    game.restart()
    game_over = false
  end
end

return game_over_state
