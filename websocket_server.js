/*eslint no-console: 0, no-unused-vars: 0*/
"use strict";
var http = require("http");
var WebSocketServer = require("websocket").server;
var express = require("express");
var bodyParser = require("body-parser");

var port = process.env.PORT || 80;
var httpServer = http.createServer();


httpServer.listen(port, function () {

    console.info("xbase_wss_device_connector HTTPs Server is up and listening von internal port: " + httpServer.address().port);

    var app = express();
    app.use(bodyParser.json({limit: '500mb'}));
    app.use(bodyParser.text({limit: '500mb'}));
    app.use(bodyParser.raw({type: 'application/zip', limit : '500mb'}));

    app.get('/', function(req, res, next) {
        console.log("http request received on /")
        res.send('<b>ELATEC websocket_server:</b>' + "<p>Report: " + JSON.stringify(process.report.getReport(),null,"<p>"));

      });
    httpServer.on("request", app);

    var webSocketServer = new WebSocketServer({
        httpServer: httpServer,
        autoAcceptConnections: false
    });

    webSocketServer.on('close', function (webSocketConnection, closeReason, description) {
        console.info("WebSocket closed", closeReason, description);
    });

    webSocketServer.on('connect', function (webSocketConnection) {
        console.info("WebSocket connected", webSocketConnection);
    });


    webSocketServer.on('request', function (request) {
        try {

            console.log("Websocket Request from  " + request.remoteAddress + ":" + request.requestedProtocols);

            try {

                var connection = request.accept('device_connector', request.origin);

                connection.elatec= {};
                connection.elatec.deviceId = request.httpRequest.headers.x2csernum;

                console.info("Device" + request.httpRequest.headers.x2csernum + " connected. IP " + connection.remoteAddress + " with user " + request.httpRequest.headers.authorization_user);

                connection.on('message', function (oMessage) {

                    try {

                        console.log("Message received: ", oMessage.utf8Data);
                        var oMessageData = JSON.parse(oMessage.utf8Data);


                    } catch (oError) {

                        console.error("Error in connection.on('message'): ", oError);

                    }

                });


                connection.on("pong", function () {
                    console.info("Heartbeat from " + connection.elatec.deviceId )
                });

	    
                connection.on('close', function (reasonCode, description) {
                    console.log("Connection.on(close). Device " + connection.elatec.deviceId);
                });

	
                connection.on("error", function (oError) {
                    console.oError("connection.on(error): ", error);

                });



            } catch (oError) {
                console.error('Error on accept: ', oError);
            }

        }
        catch (oError) {
            console.error("Error on wsServer.on('request'", oError);


        }
    });


});


