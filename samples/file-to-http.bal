import ballerina.net.fs;
import ballerina.net.http;
import ballerina.net.ei;

@fs:configuration {
    dirURI:"/home/eranda/wso2-source/ballerina-work/file-2-http/input/",
    events:"create",
    recursive:false
}
service<fs> FileProcessor {

    endpoint<ei:FileHttpClient> orderProcessorServiceEP {
        create ei:FileHttpClient("http://localhost:9090/orders", {});
    }

    resource fileResource (fs:FileSystemEvent fsEvent) {
        string filename = fsEvent.name;

        var orderProcessResponse, _ = orderProcessorServiceEP.post("/", filename);

        var orderProcessResponseJsonPayload = orderProcessResponse.getJsonPayload();
        println(orderProcessResponseJsonPayload);
    }
}


@http:configuration {basePath:"/orders"}
service<http> OrderProcessor {

    @http:resourceConfig {
        methods:["POST"],
        path:"/"
    }
    resource processOrder (http:Request request, http:Response response) {
        string payload = request.getStringPayload();
        println(payload);
        json responsePayload = {"OrderId": "12345", "Status": "Ok"};

        response.setJsonPayload(responsePayload);
        _ = response.send();
    }
}
