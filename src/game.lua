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
local persisted_state
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

game.load = function(callback, state)
    score_change_callback = callback
    persisted_state = state
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

    -- for index, flying_log in ipairs(flying_logs) do
    --     flying_log.timer = flying_log.timer + delta_time
    --     if flying_log.timer > 1.3 then
    --         table.remove(flying_logs, index)
    --     end
    -- end
    --
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

    -- for index, flying_log in ipairs(flying_logs) do
    --     local log_image = log_blank
    --     local scale_x = 1
    --     if flying_log.type == 'right' then
    --         log_image = log_right
    --     elseif flying_log.type == 'left' then
    --         log_image = log_right
    --         scale_x = -1
    --     end
    --
    --     local flying_direction = 1
    --
    --     if flying_log.direction == 'left' then
    --         flying_direction = -1
    --     end
    --
    --     local position_x = 400 + (flying_log.timer * 1000 * flying_direction)
    --     local position_y = 400 - (flying_log.timer * 300 - flying_log.timer * flying_log.timer * flying_log.timer * 100)
    --     local rotate = flying_log.timer * flying_log.rotate * flying_log.rotateSpeed
    --     love.graphics.setColor(255, 255, 255, (255 * (1 - flying_log.timer /30.3)))
    --
    --     love.graphics.draw(log_image, position_x, position_y, rotate, scale_x, 1, log_right:getWidth()/2, 0)
    -- end

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
        -- table.insert(flying_logs, {
        --     timer = 0,
        --     type = logs[1],
        --     direction = (position == "right" and "left" or "right"),
        --     rotate = (math.random() > 0.5 and 1 or -1),
        --     rotateSpeed = math.random(0.5,10)
        -- })
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
