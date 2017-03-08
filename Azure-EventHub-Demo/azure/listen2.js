request = require('request-json');
var client = request.createClient('http://localhost:8888/');
 
var data = {
  title: 'my title',
  content: 'my content'
};
client.post('posts/', data, function(err, res, body) {
  return console.log(res.statusCode);
});