var request = require('request-json');
var parseArgs = require('minimist');
var payloadFactory = require('./payload-factory');

if (process.argv.length < 3) {
  console.log("\nERROR! Missing arguments.");
  console.log("Usage: push.js --serverURL=<url> [--eventsperrequest=<number>] [--requestcount=<number>] [--requestrate=<number>] --payloadType=<normal|baddateformat|extrafield|missingfield|illegal>] \n");
  process.exit(1);
}

var arguments = parseArgs(process.argv.slice(2));

var serverURL = arguments.serverURL;
if (!serverURL) {
  console.log("\nRequired parameter serverURL missing.");
  process.exit(1);
}

var eventsPerRequest = arguments.eventsperrequest || 1;
var requestRate =  arguments.requestrate || 1;
var requestCount =  arguments.requestcount || 1;
var payloadType =  arguments.payloadtype || "normal";
var runForever = requestCount === -1;

var intervalID = setInterval(sendEvents, 1000 * 1 / requestRate, eventsPerRequest);


function getPayload(payloadtype,timeOffset)
{       
    switch(payloadtype) {
        case "baddateformat":
            return payloadFactory.getPayloadWithUTCencoding(timeOffset);
            break;
        case "extrafield":
            return payloadFactory.getPayloadWithExtraField(timeOffset);
            break;
        case "missingfield":
            return payloadFactory.getPayloadMissingField(timeOffset);
            break;
        case "illegal":
            return payloadFactory.getIllegalPayload(timeOffset);
            break;
        case "normal":
            default: 
            return payloadFactory.getNormalPayload(timeOffset);
    }
}

function sendEvents(eventsPerRequest) {
  var payload = [];
  var timeOffset = Date.now();
  for (var i = 0; i < eventsPerRequest; i++) {
    payload.push(getPayload(payloadType, timeOffset));
  }

  var start = (new Date()).getTime();
  var httpClient = request.createClient(serverURL);
  httpClient.headers['Content-Type'] = 'application/json';
  httpClient.post('', payload, function(error, response, body) {
    if (error) {
      console.log("Could not send events. Lost " + eventsPerRequest + " event(s). Error: " + error);
    }
    else {
      var stop = (new Date()).getTime();
      console.log("Sent " + eventsPerRequest + " event(s). Response: " + response.statusCode + " at " + response.headers['date'] + ". Response time " + (stop-start) + " ms");
    }
  });

  if (!runForever) {
    requestCount--;
    if (requestCount === 0) {
      clearInterval(intervalID);
    }
  }
}
