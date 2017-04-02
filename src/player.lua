local anim8 = require('src/lib/anim8')

local player = {}

local grid = anim8.newGrid(400, 400, 800, 400)
local tools = { 'golf_club', 'standard' }
local tool_spritesheets = {}
local player_spritesheet

function player.load()
    for _, name in pairs(tools) do
        tool_spritesheets[name] = love.graphics.newImage('assets/img/tools/' .. name .. '.png')
    end
    player_spritesheet = love.graphics.newImage('assets/img/man_animation.png')
end

function player.new_animation()
    return anim8.newAnimation(grid('1-2', 1), 0.1, 'pauseAtEnd')
end

function player.new()
     return {
         tool_animation = player.new_animation(),
         player_animation = player.new_animation(),
         side = 'right',
         current_tool = 'golf_club'
     }
end

function player.update(data, dt)
    data.tool_animation:update(dt)
    data.player_animation:update(dt)
end

function player.draw(data)
    local man_x
    local middle = love.graphics.getWidth()/2
    local offset = 150 * game_scale
    if data.side == 'right' then
        man_x = middle + offset
    else
        man_x = middle - offset
    end

    local scale = 0.9 * game_scale
    local draw_args = {man_x, love.graphics:getHeight() - (120 * game_scale), 0, scale, scale, 200, 400}
    data.player_animation:draw(player_spritesheet, unpack(draw_args))
    data.tool_animation:draw(tool_spritesheets[data.current_tool], unpack(draw_args))
end

function player.chop(data)
    data.player_animation:gotoFrame(1)
    data.tool_animation:gotoFrame(1)
    data.player_animation:resume()
    data.tool_animation:resume()
end

function player.change_side(data, new_side)
    if data.side ~= new_side then
        data.player_animation:flipH()
        data.tool_animation:flipH()
    end
    data.side = new_side
end

function player.get_side(data)
    return data.side
end

return player
