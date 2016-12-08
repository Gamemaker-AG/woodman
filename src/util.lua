local util = {}

function util.random_choice(items)
    return items[util.random_index(items)]
end

function util.random_index(items)
    return love.math.random(1, #items)
end

function util.pretty_print(item)
    for k, v in pairs(item) do
        print(k, v)
    end
end

return util
