var request = require('request-json');
var https = require('https');
var crypto = require('crypto');
var express    = require('express')
var bodyParser = require('body-parser')
// Shared access key (from Event Hub configuration)
var my_key_name = 'PushData';
var my_key = 'vebvJjD055jlKHi0sKyb2PdlXFgMJZRRysez05ECJ+Y=';
// Full Event Hub publisher URI
var my_uri = 'https://nvhub-ns.servicebus.windows.net/';
function create_sas_token(uri, key_name, key)
{
    // Token expires in 24 hours
    var expiry = Math.floor(new Date().getTime()/1000+3600*24);
    var string_to_sign = encodeURIComponent(uri) + '\n' + expiry;
    var hmac = crypto.createHmac('sha256', key);
    hmac.update(string_to_sign);
    var signature = hmac.digest('base64');
    var token = 'SharedAccessSignature sr=' + encodeURIComponent(uri) + '&sig=' + encodeURIComponent(signature) + '&se=' + expiry + '&skn=' + key_name;
    return token;
}

var my_sas = create_sas_token(my_uri, my_key_name, my_key)
var app = express()
app.use(bodyParser.json({"type":"*/json"}));
app.use(bodyParser.urlencoded({ extended: false }));
app.post("/", function (req, res) {
	var payload = req.body;
    var httpClient = request.createClient(my_uri);
    var devicename = payload.measure_point_number;
    console.log("*** Received a message from device: " + devicename);
    console.log(payload);
    var path ='sbcamp2016/publishers/' + devicename + '/messages';
	httpClient.headers['Authorization'] = my_sas;
    httpClient.headers['Content-Length'] = payload.length;
    httpClient.headers['Content-Type'] = 'application/atom+xml;type=entry;charset=utf-8';
    httpClient.post(path, payload, function(error, response, body) {
        res.status(200).send(); 
        return console.log("*** Forwarded to Azure servicebus, sattuscode=" + response.statusCode);
    });
});

console.log('listen')
app.listen(3000);

