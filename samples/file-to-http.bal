import ballerina.net.fs;
import ballerina.net.http;
import ei.net.extensions.file;

@fs:configuration {
    dirURI:"../../file-2-http/input/",
    events:"create",
    recursive:false
}
service<fs> FileProcessor {

    endpoint<http:HttpClient> orderProcessorServiceEP {
        create http:HttpClient("http://localhost:9090/orders", {});
    }

    resource fileResource (fs:FileSystemEvent fsEvent) {
        string filename = fsEvent.name;

        // read file content
        string content = file:readTextFile(filename);

        // create Http Request
        http:Request request = {};
        request.setStringPayload(content);

        // invoke the backend
        var orderProcessResponse, _ = orderProcessorServiceEP.post("/", request);

        // handle response
        var orderProcessResponseJsonPayload = orderProcessResponse.getJsonPayload();
        print("Response from backend: ");
        println(orderProcessResponseJsonPayload);
    }
}


@http:configuration {basePath:"/orders"}
service<http> OrderProcessorBackend {

    @http:resourceConfig {
        methods:["POST"],
        path:"/"
    }
    resource processOrder (http:Request request, http:Response response) {
        string payload = request.getStringPayload();
        json responsePayload = {"OrderId": "12345", "Status": "Ok"};

        response.setJsonPayload(responsePayload);
        _ = response.send();
    }
}
