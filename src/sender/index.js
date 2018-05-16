var AWS = require('aws-sdk')
var ses = new AWS.SES()

var RECEIVERS = [process.env.receiver];
var SENDER = process.env.sender; // make sure that the sender email is properly set up in your Amazon SES

exports.handler = (event, context, callback) => {
    console.log('Received event:', event);
    sendEmail(event, function (err, data) {
        var response = {
            "isBase64Encoded": false,
            "headers": { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': 'http://example.com' },
            "statusCode": 200,
            "body": "{\"result\": \"Success.\"}"
        };
        callback(err, response);
    });
};

function sendEmail (event, done) {

    var params = {
        Destination: {
            ToAddresses: RECEIVERS
        },
        Message: {
            Body: {
                Text: {
                    Data: 'Name: TEST' + '\nEmail: test@example.com' + '\nMessage: test message',
                    Charset: 'UTF-8'
                }
            },
            Subject: {
                Data: 'Contact Form inquiry: TEST',
                Charset: 'UTF-8'
            }
        },
        Source: SENDER
    }
    ses.sendEmail(params, done);
}
