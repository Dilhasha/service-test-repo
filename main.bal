import ballerina/http;
import ballerina/time;
import ballerina/log;

// Timeout is set to ensure no timeouts when downloading zipped logs
listener http:Listener ep = new (9097, {timeout: 720000});

int hcPrevStatus = http:STATUS_OK;
int hcPrevTimestamp = time:utcNow()[0];

const int HC_CACHED_TIME_DURATION = 30000; // 30s

final http:Client loggingEp = check new ("http://localhost:9097/loggingapi");


service /loggingapi on ep {

    resource function get healthz(http:Caller caller, http:Request req) {
        int now = time:utcNow()[0];
        int status = hcPrevStatus;
        int diff = (now - hcPrevTimestamp);
        if (diff > HC_CACHED_TIME_DURATION) {
            status = http:STATUS_OK;
            hcPrevTimestamp = now;
            hcPrevStatus = status;
        }
        http:Response res = new;
        res.statusCode = status;
        if (status == http:STATUS_OK) {
            res.setJsonPayload({status: "OK"});
        } else {
            res.setJsonPayload({status: "ERROR"});
        }
        var result = caller->respond(res);
        if (result is error) {
            log:printError("error occurred while responding to external health check request ", 'error = result);
        }
    }
}