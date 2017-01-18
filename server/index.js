var express = require('express');
var bodyParser = require('body-parser');
var connect = require('connect');
var fs = require('fs');

var app = express();
app.use(bodyParser.json());

var scores = [];

function read() {
    fs.readFile('saveonlinegame2', 'utf8', function (err, data) {
        if (err && err.code === 'ENOENT') {
            console.log("No file to read from");
        } else if (!err) {
            scores = JSON.parse(data);
            console.log("File read");
        } else {
            throw err;
        }
    });
}

function save() {
    fs.writeFile("saveonlinegame2", JSON.stringify(scores), function(err) {
        if(err) {
            return console.log(err);
        }

        console.log("The file was saved!");
    });
}

/*
*   Returns a sorted list with scores.
*
*   @param name Filters scores by given name (Optional)
*   @param begin First score to return (Optional)
*   @param end Last score to return (Optional)
*/
app.get('/getScores', function (req, res) {
    x = scores.sort(function(a,b){return b.score - a.score});

    if (req.query.name) {
        x = x.filter(function(y) { return y.name == req.query.name })
    }

    begin = req.query.begin ? req.query.begin : 0;
    x = req.query.end ? x.slice(begin, req.query.end) : x.slice(begin);
    res.send(x);
})

/*
*   Allows to post scores in json. Expected form is a json object
*   {"score":<#score>,"name":"<name>"}
*/
app.post('/', function (req, res) {
    try{
        var i = scores.findIndex(x => x.name == req.body.name);
        if (i>-1 && scores[i].score < req.body.score) {
            scores[i] = {score:req.body.score, name:req.body.name};
            res.statusCode = 200;
            save();
        } else if (i == -1) {
            scores.push({score:req.body.score, name:req.body.name});
            res.statusCode = 200;
            save();
        } else {
            res.statusCode = 409;
            res.body = "No new highscore";
        }
    } catch (err) {
        res.statusCode = 400;
    }
    res.send();
   //res.send(scores.sort(function(a,b){return b.score - a.score}));
})

console.log(__dirname)

read();

var server = app.listen(8080, function(){
    var host = server.address().address
    var port = server.address().port

    console.log("Example app listening at http://%s:%s", host, port)
})
