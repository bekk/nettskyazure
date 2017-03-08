var https = require('https');
var crypto = require('crypto');
var express    = require('express')
var bodyParser = require('body-parser')
var namespace = 'nvhub-ns';
var hubname ='nvhub';
var devicename = 'device-01';
// Shared access key (from Event Hub configuration)
var my_key_name = 'PushData';
var my_key = 'iFdiG6Khw6fTsJM5YAcec790NYrJUflrMRYVTkIDBxM=';
// Full Event Hub publisher URI
var my_uri = 'https://' + namespace + '.servicebus.windows.net' + '/' + hubname + '/publishers/' + devicename + '/messages';
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
app.use(bodyParser.json());
app.use(function (req, res, next) {
	var payload = req.body;
	console.log(payload) // populated
	var options = {
		hostname: namespace + '.servicebus.windows.net',
  		port: 443,
  		path: '/' + hubname + '/publishers/' + devicename + '/messages',
  		method: 'POST',
  		headers: {
    		'Authorization': my_sas,
    		'Content-Length': req.body.length,
    		'Content-Type': 'application/atom+xml;type=entry;charset=utf-8'
  		}
  	};

	var req = https.request(options, function(res) {
		console.log("statusCode: ", res.statusCode);
		console.log("headers: ", res.headers);
		res.on('data', function(d) {
    		process.stdout.write(d);
  		});
  	});

	res.on('data', function(d) {
    	process.stdout.write(d);
  	});

	req.on('error', function(e) {
  		console.error(e);
	});

	//req.write( '[{\"Temperature\":\"'+1+'\",\"Humidity\":\"'+1+'\"}]');
	req.write(payload);
	req.end();
	next()
});

console.log('listen')
app.listen(3000);

