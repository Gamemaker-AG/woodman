local util = require('src/util')

local splinter
local base, canopy
local tree = {}

local images = {
    blank = {},
    branch = {}
}

local level_length = 3

function tree.load()
    splinter = love.graphics.newImage('assets/img/particles/splinter.png')
    base = love.graphics.newImage('assets/img/tree/base.png')
    canopy = love.graphics.newImage('assets/img/tree/canopy.png')
    table.insert(images.blank, love.graphics.newImage('assets/img/tree/blank_1.png'))
    table.insert(images.blank, love.graphics.newImage('assets/img/tree/blank_2.png'))
    table.insert(images.blank, love.graphics.newImage('assets/img/tree/blank_3.png'))
    table.insert(images.branch, love.graphics.newImage('assets/img/tree/branch_1.png'))
end

function tree.generate_initial_level()
    local new_level = {
        logs={tree.new_log('blank')},
        emitters=tree.initialize_emitters(),
        gap = 0
    }
    for i = 1, level_length, 1 do
        table.insert(new_level.logs, tree.generate_log(new_level))
    end

    return new_level
end

function tree.initialize_emitters()
    local emitters = {}
    local emitter = love.graphics.newParticleSystem(splinter, 35)
    emitter:setAreaSpread("normal", 20, 10)
    emitter:setEmissionRate(60)
    emitter:setEmitterLifetime(0.1)
    emitter:setLinearAcceleration(0, 800, 0, 1000)
    emitter:setParticleLifetime(0.1, 0.8)
    emitter:setRadialAcceleration(5, 22)
    emitter:setRotation(-1.7, 2.7)
    emitter:setTangentialAcceleration(0, 0)
    emitter:setSpeed(300, 1000)
    emitter:setLinearDamping(0, 0)
    emitter:setSpread(math.pi/3)
    emitter:setRelativeRotation(false)
    emitter:setOffset(10, 10)
    emitter:setSizes(3)
    emitter:setSizeVariation(1)
    emitter:setColors(100, 68, 22, 255, 100, 68, 22, 0)
    table.insert(emitters, emitter)

    local emitter = emitter:clone()
    emitter:setSizes(1)
    table.insert(emitters, emitter)

    local emitter = emitter:clone()
    emitter:setSizes(2)
    table.insert(emitters, emitter)

    return emitters
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

function tree.generate_log(data)
    if data.logs[#data.logs].type == 'blank' then
        if data.logs[#data.logs-1] and data.logs[#data.logs-1].direction == 'right' then
            return tree.new_log('branch', 'left')
        else
            return tree.new_log('branch', 'right')
        end
    else
        if love.math.random() < 0.5 * math.pow(0.9, savegame.get_cloverleaf(persisted_state)) then
            return tree.new_log('blank')
        else
            local last_log = data.logs[#data.logs]
            return tree.new_log(last_log.type, last_log.direction)
        end
    end
end

function tree.draw(data)
    love.graphics.setColor(255, 255, 255, 255)

    local canopy_y = love.graphics.getHeight() - #data.logs * images['blank'][1]:getHeight() - 200
    love.graphics.draw(
      canopy,
      love.graphics.getWidth()/2, canopy_y,
      0,
      1, 1,
      canopy:getWidth()/2, canopy:getHeight()
    )

    for index, log in ipairs(data.logs) do
        log_image = images['blank'][log.index]
        scale_x = 1
        if log.direction == 'left' then
            scale_x = -1
        end

        local y_pos = love.graphics.getHeight() - (index * log_image:getHeight()) - data.gap - 200

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

    for _, system in ipairs(data.emitters) do
        love.graphics.draw(
            system,
            love.graphics.getWidth()/2,
            love.graphics.getHeight() - 200 - (images.blank[1]:getHeight() / 2)
        )
    end

    love.graphics.draw(base,
        love.graphics.getWidth()/2 - 5, love.graphics.getHeight() - 200,
        0,
        1, 1,
        base:getWidth()/2, 0
    )
end

function tree.update(data, dt)
    for _, system in ipairs(data.emitters) do
        system:update(dt)
    end
    data.gap = math.max(0, data.gap - (dt * 2000))
end

function tree.chop(data, side)
    table.insert(data.logs, tree.generate_log(data))
    local middle = -math.pi/2
    local tilt = math.pi/3
    for _, emitter in ipairs(data.emitters) do
        if side == "left" then
            emitter:setDirection(middle + tilt)
        else
            emitter:setDirection(middle - tilt)
        end
        emitter:start()
    end
    table.remove(data.logs, 1)
    data.gap = log_image:getHeight()
end

function tree.is_legal_move(data, side)
    return data.logs[1].direction == side or data.logs[2].direction == side
end

return tree
