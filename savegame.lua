local bitser = require("lib/bitser")
local savegame = {}

savegame.load = function()
    if love.filesystem.exists("savegame") then
        return bitser.loads(love.filesystem.read("savegame"))
    end
    return {scores = {{"Nobody", 1}}}
end

local function compare(a, b)
    return a[2] > b[2]
end

savegame.save = function(state)
    local succ = love.filesystem.write("savegame", bitser.dumps(state))
    if succ then
        print("Saved")
    else
        print("Saving failed :(")
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
    return scores
end

return savegame
