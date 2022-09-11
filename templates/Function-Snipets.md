Function header
```
@HttpTrigger(name = "req", methods = {HttpMethod.POST},
authLevel = AuthorizationLevel.FUNCTION,
dataType = "binary") HttpRequestMessage<Optional<byte[]>> request,
final ExecutionContext context
```

1) Init upload Serivce
```
logger = context.getLogger();
logger.info("Java HTTP file upload started with headers " + request.getHeaders());
FileUploadService uploadSerivce = new FileUploadService(logger);
```
2) Upload Image
```
byte[] bs = request.getBody().get();
String fileName = uploadSerivce.getFileName(request.getHeaders());
String url = uploadSerivce.upload(bs, fileName);
```
3) Generate SAS token and URL
```
String sas = uploadSerivce.generateUserDelegationSASToken(fileName);
String blobUrl = url + "?" + sas;
```
4) send image to cognitive service and upload result as JSON
```
CognitiveServiceClientProvider cognitiveServiceClientProvider = new CognitiveServiceClientProvider(logger);
String analysisResultBody = cognitiveServiceClientProvider.sendRequest(blobUrl);
byte[] data = analysisResultBody.getBytes();
uploadSerivce.upload(data, fileName + ".json");
```
5) return response
```
logger.info("Java HTTP file upload ended. Length: " + bs.length);
return request.createResponseBuilder(HttpStatus.OK).body("Successfully analyzed " + fileName).build();
```