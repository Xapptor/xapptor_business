var stream = require('node-rtsp-stream')

const serial_number = process.argv[2]
const ip = process.argv[3]
const port = process.argv[4]

stream = new stream({
    name: 'name',
    streamUrl: `rtsp://admin:${serial_number}@${ip}`,
    wsPort: port
});