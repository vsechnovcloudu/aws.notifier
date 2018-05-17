var AWS = require('aws-sdk')
var ses = new AWS.SES()

var RECEIVERS = [process.env.receiver];
var SENDER = process.env.sender; // make sure that the sender email is properly set up in your Amazon SES
var ORIGIN = process.env.origin;

exports.handler = (event, context, callback) => {
    console.log('Received event:', event);
    sendEmail(event, function (err, data) {
        var response = {
            "isBase64Encoded": false,
            "headers": { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': ORIGIN },
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
                    Data: 'Name: ' + event.name + '\nEmail: ' + event.email + '\nMessage: ' + event.message,
                    Charset: 'UTF-8'
                }
            },
            Subject: {
                Data: 'Contact Form inquiry: ' + event.name,
                Charset: 'UTF-8'
            }
        },
        Source: SENDER
    }
    ses.sendEmail(params, done);
}
