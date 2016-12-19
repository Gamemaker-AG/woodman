local savegame = require('src/savegame')
local tree = require('src/tree')
local player = require('src/player')

game = {}

local squirrel
local score = 0
local chopwood_audio
local audioNewHighscore
local nuts_timer
local score_change_callback
local logs
local player_data

game.restart = function()
    score = 0
    death_timer = 10
    game_over = false
    logs = tree.generate_initial_level()
    player_data = player.new()
    nuts_timer = 0
end

game.load = function(callback)
    score_change_callback = callback
    audioNewHighscore = love.audio.newSource('assets/sounds/improved_highscore.mp3', 'static')
    squirrel = love.graphics.newImage('assets/img/squirrel.png')
    chopwood_audio = love.audio.newSource('assets/sounds/chop_wood.mp3', 'static')
    tree.load()
    player.load()
end

game.update = function(delta_time)
    death_timer = death_timer - delta_time

    if death_timer <= 0 then
        show_game_over_state()
    end

    tree.update(logs, delta_time)

    if nuts_timer <= 0 and savegame.get_nuts(persisted_state) > 0 then
        if math.random() < 0.003 then
            nuts_timer = 1
            savegame.decrement_nuts(persisted_state)
            savegame.save(persisted_state)
        end
    elseif nuts_timer > 0 then
        nuts_timer = nuts_timer - delta_time
    end

    player.update(player_data, delta_time)
end

game.keypressed = function(key)
    if key == 'right' or key == 'left' then
        player.change_side(player_data, key)
        chop()
    elseif key == 'space' then
        if nuts_timer > 0 then
            score = score + 5
            nuts_timer = 0
        else
            score = score - 1
        end
    end
end

game.draw = function()
    tree.draw(logs)
    player.draw(player_data)

    love.graphics.setColor(0, 0, 0)
    love.graphics.print('Score:', 30, 50)
    love.graphics.print(score, 73, 50)
    love.graphics.print('Highscore:', 680, 50)
    love.graphics.print(savegame.getPrettyHighscore(persisted_state), 680, 70)

    love.graphics.rectangle('line', 100, 50, 100 * (death_timer/10), 20)

    if nuts_timer > 0 then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(squirrel, 691, 0)
    end
end

function chop()
    if tree.is_legal_move(logs, player.get_side(player_data)) then
        show_game_over_state()
    else
        player.chop(player_data)
        tree.chop(logs, player.get_side(player_data))

        chop_timer = 0
        score = score + 1

        if score % 10 == 0 then
            savegame.add_coins(persisted_state, 1)
        end
        chopwood_audio:play()
        if savegame.getHighscore(persisted_state) + 1 == score then
            audioNewHighscore:play()
        end
        death_timer = math.min(death_timer + (1/score), 10)
    end
end

function show_game_over_state()
    game_over_state.restart()
    current_state = game_over_state
end

game.getScore = function()
    return score
end

game.mousepressed = function(x, y, button, istouch)

end

return game
