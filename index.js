const writeStream = require('./src/streams/actions/writeStream.js'),
      eventMessages = require('./src/streams/events/eventMessages.js'),
      streamName = 'StartWeatherFetch',
      timeZone = process.argv[2];

writeStream(streamName, eventMessages[timeZone]);
