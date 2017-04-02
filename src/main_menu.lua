local main_menu = {}

local bg
local arrow
local tab

function main_menu.load()
    bg = love.graphics.newImage('assets/img/main_menu.png')
    arrow = love.graphics.newImage('assets/img/arrow.png')
    tab = love.graphics.newImage('assets/img/tab.png')
end

function main_menu.keypressed(key)
    if key == 'return' then
        current_state = game
    elseif key == 'tab' then
        current_state = coins
    end
end

function main_menu.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(bg, 0, 0)
    love.graphics.draw(arrow, love.graphics.getWidth()-80, love.graphics.getHeight()-212, 0, 0.15, 0.15)
    love.graphics.draw(arrow, love.graphics.getWidth()-20, love.graphics.getHeight()-115, math.pi, 0.15, 0.15)
    love.graphics.draw(tab, love.graphics.getWidth()-75, love.graphics.getHeight()-100, 0, 0.18, 0.18)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('Press right to chop the right side of the tree', love.graphics.getWidth()-370, love.graphics.getHeight()-200)
    love.graphics.print('Press left to chop the right side of the tree', love.graphics.getWidth()-370, love.graphics.getHeight()-140)
    love.graphics.print('Press tab after the game to invest your coins', love.graphics.getWidth()-370, love.graphics.getHeight()-80)
    love.graphics.setFont(semiLargeFont)
    love.graphics.print('Controls', love.graphics.getHeight()-350, love.graphics.getHeight()-260)
    love.graphics.setFont(normalFont)
    love.graphics.print('Press enter to play', 50, love.graphics.getHeight()-50)
    love.graphics.setColor(255, 255, 255)
end

return main_menu
