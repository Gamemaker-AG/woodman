local serialize = require("ser")
local scores = {{"Nobody", 0}}
scoreboard = {}

if love.filesystem.exists("savegame.lua") then
    scores, _ = require("savegame")
end

function compare(a, b)
    return a[2] > b[2]
end

scoreboard.save = function()
    local succ = love.filesystem.write("savegame.lua", serialize(scores))
    if succ then
        print("Saved")
    else
        print("Saving failed :(")
    end
end

scoreboard.getHighscore = function()
    table.sort(scores, compare)
    return scores[1][2]
end

scoreboard.getPrettyHighscore = function()
    table.sort(scores, compare)
    local n, s = unpack(scores[1])
    return s .. ' (' .. n .. ')'
end


scoreboard.setHighscore = function(name, score)
    table.insert(scores, 1, {name, score})
end

return scoreboard
