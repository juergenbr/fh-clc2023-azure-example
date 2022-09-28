package com.breitenbaumer;

import com.breitenbaumer.shared.CognitiveService;
import com.breitenbaumer.shared.FileUploadService;
import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.HttpMethod;
import com.microsoft.azure.functions.HttpRequestMessage;
import com.microsoft.azure.functions.HttpResponseMessage;
import com.microsoft.azure.functions.HttpStatus;
import com.microsoft.azure.functions.annotation.AuthorizationLevel;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.HttpTrigger;

import java.util.Optional;
import java.util.logging.Logger;

/**
 * Azure Functions with HTTP Trigger.
 */
public class Function {

  private Logger logger;

  @FunctionName("blobStorageUpload")
  public HttpResponseMessage run(
      @HttpTrigger(name = "req", methods = {HttpMethod.POST},
          authLevel = AuthorizationLevel.FUNCTION,
          dataType = "binary") HttpRequestMessage<Optional<byte[]>> request,
      final ExecutionContext context) throws Exception {

    logger = context.getLogger();
    // start file upload
    logger.info("Java HTTP file upload started with headers " + request.getHeaders());

    // init file uploader service
    FileUploadService uploadSerivce = new FileUploadService(logger);

    // here the "content-type" must be lower-case
    byte[] bs = request.getBody().get();
    String fileName = uploadSerivce.getFileName(request.getHeaders());
    String url = uploadSerivce.upload(bs, fileName);
    String sas = uploadSerivce.generateUserDelegationSASToken(fileName);
    String blobUrl = url + "?" + sas;
    // send image to cognitive service and upload result as JSON
    CognitiveService cognitiveServiceClientProvider =
        new CognitiveService(logger);
    String analysisResultBody = cognitiveServiceClientProvider.sendRequest(blobUrl);
    byte[] data = analysisResultBody.getBytes();
    uploadSerivce.upload(data, fileName + ".json");
    // return response
    logger.info("Java HTTP file upload ended. Length: " + bs.length);
    return request.createResponseBuilder(HttpStatus.OK).body("Hello, " + bs.length).build();
  }

}
