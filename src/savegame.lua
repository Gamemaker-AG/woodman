local bitser = require("lib/bitser")
local webscore = require("lib/webscore")
local savegame = {}

savegame.load = function()
    if love.filesystem.exists("savegame2") then
        return bitser.loads(love.filesystem.read("savegame2"))
    end
    return {
        scores = {
            {"Nobody", 0}
        },
        collected_coins = 60,
        bought_cloverleaf = 0,
        bought_nuts = 0
    }
end

local function compare(a, b)
    return a[2] > b[2]
end

savegame.save = function(state)
    local succ = love.filesystem.write("savegame2", bitser.dumps(state))
    local websucc = webscore.sendScore(state.scores[1][2], state.scores[1][1])
    if succ then
        print("Saved")
    else
        print("Saving failed :(")
    end
    if websucc then
        print("Webscore saved")
    else
        print("Webscore not saved")
    end
end

savegame.getHighscore = function(state)
    table.sort(state.scores, compare)
    return state.scores[1][2]
end

savegame.getPrettyHighscore = function(state)
    table.sort(state.scores, compare)
    local n, s = unpack(state.scores[1])
    return s .. ' (' .. n .. ')'
end

savegame.add_score = function(state, name, score)
    table.insert(state.scores, 1, {name, score})
end

savegame.add_coins = function(state, number)
    state.collected_coins = state.collected_coins + number
end

savegame.getCoins = function(state)
    return state.collected_coins
end

savegame.add_cloverleaf = function(state)
    state.bought_cloverleaf = state.bought_cloverleaf + 1
end

savegame.add_nuts = function(state)
    state.bought_nuts = state.bought_nuts + 3
end

savegame.decrement_nuts = function(state)
    state.bought_nuts = state.bought_nuts - 1
end

savegame.get_nuts = function(state)
    return state.bought_nuts
end

savegame.get_cloverleaf = function(state)
    return state.bought_cloverleaf
end

return savegame
