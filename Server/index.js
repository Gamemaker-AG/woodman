var express = require('express');
var bodyParser = require('body-parser');
var connect = require('connect');
var app = express();
app.use(bodyParser.json());

scores = []

/*app.get('/', function(req, res) {
    x = scores.sort(function(a,b){return b.score - a.score});

})*/

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
        console.log(i);
        if (i>-1 && scores[i].score < req.body.score) {
            scores[i] = {score:req.body.score, name:req.body.name};
            res.statusCode = 200;
        } else if (i == -1) {
            scores.push({score:req.body.score, name:req.body.name});
            res.statusCode = 200;
        } else {
            res.statusCode = 409;
            res.body = "No new highscore";
        }

        res.send();
    } catch (err) {
        res.statusCode = 400;
        res.send();
    }

   //res.send(scores.sort(function(a,b){return b.score - a.score}));
})

console.log(__dirname)

var server = app.listen(80, function(){
    var host = server.address().address
    var port = server.address().port

    console.log("Example app listening at http://%s:%s", host, port)
})
