local util = require('src/util')

local tree = {}

local images = {
    blank = {},
    branch = {}
}

local level_length = 4

function tree.load()
    table.insert(images.blank, love.graphics.newImage('assets/img/tree/blank_1.png'))
    table.insert(images.blank, love.graphics.newImage('assets/img/tree/blank_2.png'))
    table.insert(images.blank, love.graphics.newImage('assets/img/tree/blank_3.png'))
    table.insert(images.branch, love.graphics.newImage('assets/img/tree/branch_1.png'))
end

function tree.generate_initial_level()
    local new_level = {tree.new_log('blank')}
    for i = 1, level_length, 1 do
        table.insert(new_level, tree.generate_log(new_level))
    end

    return new_level
end

function tree.new_log(type, direction)
    local log = {
        type = type,
        index = util.random_index(images['blank']),
        direction = direction
    }
    if type == 'branch' then
        log.branch_index = util.random_index(images['branch'])
    end
    return log
end

function tree.generate_log(logs)
    if logs[#logs].type == 'blank' then
        if logs[#logs-1] and logs[#logs-1].direction == 'right' then
            return tree.new_log('branch', 'left')
        else
            return tree.new_log('branch', 'right')
        end
    else
        if love.math.random() < 0.5 then
            return tree.new_log('blank')
        else
            local last_log = logs[#logs]
            return tree.new_log(last_log.type, last_log.direction)
        end
    end
end

function tree.draw(logs)
    love.graphics.setColor(255, 255, 255, 255)
    for index, log in ipairs(logs) do
        log_image = images['blank'][log.index]
        scale_x = 1
        if log.direction == 'left' then
            scale_x = -1
        end

        local y_pos = love.graphics.getHeight() - (index * (log_image:getHeight() - 5))

        love.graphics.draw(
            log_image,
            love.graphics.getWidth()/2, y_pos,
            0,
            scale_x, 1,
            log_image:getWidth()/2, 0
        )

        if log.type == 'branch' then
            local branch_image = images['branch'][log.branch_index]
            love.graphics.draw(
                branch_image,
                love.graphics.getWidth()/2 + (150 * scale_x), y_pos,
                0,
                scale_x, 1,
                branch_image:getWidth()/2, 0
            )
        end
    end
end

function tree.chop(logs)
    table.insert(logs, tree.generate_log(logs))
    table.remove(logs, 1)
end

function tree.is_legal_move(logs, side)
    return logs[1].direction == side or logs[2].direction == side
end

return tree
