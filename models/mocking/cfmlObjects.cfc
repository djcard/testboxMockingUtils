component {

/***
 * 
 * 
 * */



    fileUpload(
        attemptedServerFile="",
        clientDirectory="",
        clientFile="",
        clientFileExt="",
        clientFileName="",
        contentSubType="",
        contentType="",
        dateLastAccessed="",
        fileExisted="",
        fileSize="",
        fileWasAppended="",
        fileWasOverwritten="",
        fileWasRenamed="",
        fileWasSaved="",
        oldFileSize="",
        serverDirectory="",
        serverFile="",
        serverFileExt="",
        serverFileName="",
        timeCreated="",
        timeLastModified=""
    ) {
        return {
            attemptedServerFile:attemptedServerFile,
            clientDirectory:clientDirectory,
            clientFile:clientFile,
            clientFileExt:clientFileExt,
            clientFileName:clientFileName,
            contentSubType:contentSubType,
            contentType:contentType,
            dateLastAccessed:dateLastAccessed
            fileExisted:fileExisted,
            fileSize:fileSize
            fileWasAppended:fileWasAppended,
            fileWasOverwritten:fileWasOverwritten,
            fileWasRenamed:fileWasRenamed,
            fileWasSaved:fileWasSaved,
            oldFileSize:oldFileSize,
            serverDirectory:serverDirectory,
            serverFile:serverFile,
            serverFileExt:serverFileExt,
            serverFileName:serverFileName,
            timeCreated:timeCreated,
            timeLastModified:timeLastModified
        }
    }
}