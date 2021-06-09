import ballerina/test;
@test:Config{}
function testFunc() {
    test:assertEquals(intAddd(1,2), 3);
}