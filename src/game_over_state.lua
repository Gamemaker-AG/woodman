local savegame = require("./src/savegame")
local webscore = require("lib/webscore")

local game_over_state = {}

local pwnd_image
local new_highscore
local player_name
local audio_game_over
local audio_highscore
local new_score_callback

game_over_state.load = function(callback)
    new_score_callback = callback
    pwnd_image = love.graphics.newImage('assets/img/pwnd.png')
    new_highscore = love.graphics.newImage('assets/img/new_highscore.png')
    audio_game_over = love.audio.newSource('assets/sounds/game_over.mp3')
    audio_highscore = love.audio.newSource('assets/sounds/highscore.mp3')
    tab = love.graphics.newImage('assets/img/tab.png')
end

game_over_state.restart = function()
    if game.getScore() > savegame.getHighscore(persisted_state) then
        audio_highscore:play()
    else
        audio_game_over:play()
    end
    player_name = ''
end

game_over_state.draw = function()
    love.graphics.setColor(255, 255, 255)

    if game.getScore() > savegame.getHighscore(persisted_state) then
        love.graphics.draw(new_highscore, 0, 0)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(largeFont)
        love.graphics.print('You scored ' .. game.getScore() .. '!', love.graphics.getWidth()/2-150, love.graphics.getHeight()-200)
        love.graphics.print('Name: ' .. player_name, love.graphics.getWidth()/2-150, love.graphics.getHeight()-120)
        love.graphics.setFont(normalFont)
    else
        love.graphics.draw(pwnd_image, 0, 0)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(semiLargeFont)
        love.graphics.print('Your Score: ' .. game.getScore(), love.graphics.getWidth()/2-50, love.graphics.getHeight()-250)
        love.graphics.print('Current Highscore: ' .. savegame.getHighscore(persisted_state), love.graphics.getWidth()/2-90, love.graphics.getHeight()-200)
        love.graphics.setFont(normalFont)
    end

    love.graphics.draw(tab, love.graphics.getWidth()-75, love.graphics.getHeight()-100, 0, 0.18, 0.18)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('(press return to continue)', love.graphics.getWidth()/2-80, love.graphics.getHeight()-40)
    love.graphics.print('Press tab after the game to invest your coins', love.graphics.getWidth()-370, love.graphics.getHeight()-80)
end

game_over_state.keypressed = function(key)
    if key == 'return' then
        if game.getScore() > savegame.getHighscore(persisted_state) then
            new_score_callback(player_name, game.getScore())
            savegame.save(persisted_state)
        end
        audio_highscore:stop()
        audio_game_over:stop()
        game.restart()
        current_state = game
    elseif key == 'tab' then
        current_state = coins
    elseif game.getScore() > savegame.getHighscore(persisted_state) then
        if key == 'backspace' then
            player_name = string.sub(player_name, 1, #player_name - 1)
        elseif key == 'space' then
            player_name = player_name .. ' '
        elseif key == string.match(key, '%w?-?') then
            if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
                key = string.upper(key)
            end
            player_name = player_name .. key
        end
    end
end

return game_over_state
