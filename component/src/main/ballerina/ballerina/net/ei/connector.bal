package ballerina.net.ei;

import ballerina.net.http;
import ballerina.io;
import ballerina.file;

public function readTextFile(string fileName) (string) {
    io:CharacterChannel srcRecordChannel = getCharacterChannel(fileName, "r", "UTF-8", "\\r?\\n", ",");
    string content =  srcRecordChannel.readAllCharacters();
    srcRecordChannel.closeCharacterChannel();
    return content;
}

public connector FileHttpClient (string serviceUri, http:Options connectorOptions) {

    endpoint<http:HttpClient> httpEP {
        create http:HttpClient(serviceUri, connectorOptions);
    }

    action post (string path, string fileName) (http:Response, http:HttpConnectorError) {
        return httpEP.post(path, buildHttpRequest(fileName));
    }
}

function buildHttpRequest (string fileName) (http:Request) {
    io:CharacterChannel srcRecordChannel = getCharacterChannel(fileName, "r", "UTF-8", "\\r?\\n", ",");
    string content = srcRecordChannel.readAllCharacters();

    http:Request request = {};
    request.setStringPayload(content);

    srcRecordChannel.closeCharacterChannel();

    return request;
}

function getCharacterChannel (string filePath, string permission, string encoding, string rs, string fs) (io:CharacterChannel) {
    file:File src = {path:filePath};
    io:ByteChannel channel = src.openChannel(permission);
    io:CharacterChannel characterChannel = channel.toCharacterChannel(encoding);
    return characterChannel;
}