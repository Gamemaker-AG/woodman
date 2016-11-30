function love.load()
    names = { "Emma","Liam","Noah","Olivia","Ethan","Sophia","Ava","Mason","Lucas","Mia","Isabella","Logan","Charlotte","Oliver","Amelia","Jackson","Aiden","Harper","Emily","Jacob","Elijah","Madison" }
    x = love.math.newRandomGenerator( )
    for i = 0,1000,1 do
        name = names[x:random( #names )]
        number = x:random( ) * 100
        sendReq(number, name)
    end

    love.graphics.setBackgroundColor(50,50,50)

end

function sendReq(score, nm)
    local http = require('socket.http')
    local ltn12 = require('ltn12')

    local payload = '{"score":'..score..',"name":"'..nm..'"}'

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
end
