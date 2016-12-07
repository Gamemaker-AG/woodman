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
        print("not saved")
        return false
    end
end

return webscore
