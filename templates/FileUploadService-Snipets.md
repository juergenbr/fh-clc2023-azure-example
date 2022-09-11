(1) init function
this.logger = logger;
this.provider = new BlobClientProvider(logger);
this.blobServiceClient = provider.getBlobServiceClient();
```

(2) create blob client deoending on file type
```
if(fileName.endsWith(".json")){
    blobClient = provider.getBlobClient(resultContainer.getBlobContainerName(), fileName);
}
else{
    blobClient = provider.getBlobClient(imageContainer.getBlobContainerName(), fileName);
}
```
(3)) upload file to blob storage
```
logger.info("\n\tUploading" + fileName + " to container " + blobClient.getContainerName());
blobClient.upload(BinaryData.fromBytes(content), true);
logger.info("\t\tSuccessfully uploaded the blob.");
```
(4))) return blob url
```
return blobClient.getBlobUrl();
```