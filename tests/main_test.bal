import ballerina/http;
import ballerina/io;
import ballerina/test;

@test:Config {}
function testPublicHealthCheck() returns error? {
    io:println("Testing publich health check endpoint...");
    http:Response response = check loggingEp->get("/healthz");
    test:assertEquals(response.statusCode, http:STATUS_OK);
    json payload = check response.getJsonPayload();
    test:assertEquals(payload.toString(), "{\"status\":\"OK\"}");
}
