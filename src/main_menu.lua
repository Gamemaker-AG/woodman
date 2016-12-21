local main_menu = {}

local bg

function main_menu.load()
    bg = love.graphics.newImage('assets/img/main_menu.png')
end

function main_menu.keypressed(key)
    if key == 'return' then
        current_state = game
    end
end

function main_menu.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(bg, 0, 0)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('Press enter to play', 50, love.graphics.getHeight()-50)
    love.graphics.setColor(255, 255, 255)
end

return main_menu
