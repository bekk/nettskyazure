var uuid = require('uuid');

module.exports = {
	getNormalPayload: function getNormalPayload(timeOffset) {
        return {
            measure_point_number: Math.floor(1500000 + 30 * Math.random()),
            timestamp: new Date().toISOString(),
            event_number: timeOffset,
            speed: parseFloat((60 + 30 * Math.random()).toFixed(1)), 
            lane: Math.floor(1 + 3 * Math.random())
        };
	},
	getPayloadWithUTCencoding: function getPayloadWithUTCencoding(timeOffset) {
        return {
            measure_point_number: Math.floor(1500000 + 30 * Math.random()),
            timestamp: new Date().toUTCString(),
            event_number: timeOffset,
            speed: parseFloat((60 + 30 * Math.random()).toFixed(1)), 
            lane: Math.floor(1 + 3 * Math.random())
        };
	},
    getPayloadWithExtraField: function getPayloadWithExtraField(timeOffset) {
        return {
            measure_point_number: Math.floor(1500000 + 30 * Math.random()),
            timestamp: new Date().toISOString(),
            event_number: timeOffset,
            speed: parseFloat((60 + 30 * Math.random()).toFixed(1)), 
            lane: Math.floor(1 + 3 * Math.random()),
            unknowfield: uuid.v4()
        };
	},
    getPayloadMissingField: function getPayloadMissingField(timeOffset) {
        return {
            measure_point_number: Math.floor(1500000 + 30 * Math.random()),
            timestamp: new Date().toISOString(),
            event_number: timeOffset,
            lane: Math.floor(1 + 3 * Math.random()),
        };
	},
    getIllegalPayload: function getPayloadMissingField(timeOffset) {
        return "æ"
	}
}