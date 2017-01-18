local webscore = {}

webscore.sendScore = function(score, name)
    local http = require('socket.http')
    local ltn12 = require('ltn12')

    local payload = '{"score":'..score..',"name":"'..name..'"}'

    local res, code, response_headers, status = http.request
    {
        url = "http://127.0.0.1",
        method = "POST",
        headers =
            {
              ["Content-Type"] = "application/json",
              ["Content-Length"] = payload:len()
            },
        source = ltn12.source.string(payload),
        sink = ltn12.sink.table(response_body)
    }

    if code == 200 then
        print("saved")
        return true
    else
        print("not saved: " .. code)
        return false
    end
end

webscore.getScores = function()
    local http = require("socket.http")
    local json = require("lib/json")
    local result, statuscode, content = http.request("http://127.0.0.1/getScores")
    if(statuscode == 200) then
        local res = json.parse(result)
        return res
    else
        return nil
    end
end

return webscore
