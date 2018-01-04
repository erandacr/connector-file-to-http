package ballerina.net.ei;

import ballerina.io;
import ballerina.file;

public function readTextFile(string fileName) (string) {
    io:CharacterChannel srcRecordChannel = getCharacterChannel(fileName, "r", "UTF-8");
    string content =  srcRecordChannel.readAllCharacters();
    srcRecordChannel.closeCharacterChannel();
    return content;
}

function getCharacterChannel (string filePath, string permission, string encoding) (io:CharacterChannel) {
    file:File src = {path:filePath};
    io:ByteChannel channel = src.openChannel(permission);
    io:CharacterChannel characterChannel = channel.toCharacterChannel(encoding);
    return characterChannel;
}