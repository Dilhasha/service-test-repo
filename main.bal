import ballerina/http;
import ballerina/log;
import ballerina/io;

// Timeout is set to ensure no timeouts when downloading zipped logs
listener http:Listener ep = new (9097, {timeout: 720000});

final http:Client loggingEp = check new ("http://localhost:9097/loggingapi");


service /loggingapi on ep {

    resource function get health(http:Caller caller, http:Request req) {
        int answer = 8;
        if (false) {
            int a = 9;
            int b = 1;
            answer = a + b;
        }
        io:println(answer);
        http:Response res = new;
        res.statusCode = http:STATUS_OK;
        res.setJsonPayload({status: "OK"});
        var result = caller->respond(res);
        if (result is error) {
            log:printError("error occurred while responding to external health check request ", 'error = result);
        }
    }
}