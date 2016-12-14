local savegame = require('src/savegame')
local tree = require('src/tree')
game = {}

local man
local man2
local squirrel
local score = 0
local chopwood_audio
local audioNewHighscore
local nuts_timer
local score_change_callback
local logs

game.restart = function()
    score = 0
    chop_timer = 1
    position = 'right'
    death_timer = 10
    game_over = false
    logs = tree.generate_initial_level()
    nuts_timer = 0
end

game.load = function(callback)
    score_change_callback = callback
    man = love.graphics.newImage('assets/img/man.png')
    man2 = love.graphics.newImage('assets/img/man2.png')
    audioNewHighscore = love.audio.newSource('assets/sounds/improved_highscore.mp3', 'static')
    squirrel = love.graphics.newImage('assets/img/squirrel.png')
    chopwood_audio = love.audio.newSource('assets/sounds/chop_wood.mp3', 'static')
    tree.load()
end

game.update = function(delta_time)
    chop_timer = chop_timer + delta_time
    death_timer = death_timer - delta_time

    if death_timer <= 0 then
        show_game_over_state()
    end

    if nuts_timer <= 0 and savegame.get_nuts(persisted_state) > 0 then
        if math.random() < 0.003 then
            nuts_timer = 1
            savegame.decrement_nuts(persisted_state)
            savegame.save(persisted_state)
        end
    elseif nuts_timer > 0 then
        nuts_timer = nuts_timer - delta_time
    end
end

game.keypressed = function(key)
    if key == 'right' then
        position = 'right'
        chop()
    elseif key == 'left' then
        position = 'left'
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

    tree.draw(logs)

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
    if tree.is_legal_move(logs, position) then
        show_game_over_state()
    else
        tree.chop(logs)
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
