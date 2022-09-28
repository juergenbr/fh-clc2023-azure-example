package com.breitenbaumer;

import com.breitenbaumer.shared.CustomVisionService;
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
public class CustomVisionFunction {

  private Logger logger;

  @FunctionName("classifyImage")
  public HttpResponseMessage run(
      @HttpTrigger(name = "req", methods = {HttpMethod.POST},
          authLevel = AuthorizationLevel.FUNCTION,
          dataType = "binary") HttpRequestMessage<Optional<byte[]>> request,
      final ExecutionContext context) throws Exception {
    
        String result = "";
    logger = context.getLogger();
    // start file upload
    logger.info("Java HTTP file upload started with headers " + request.getHeaders());

    byte[] image = request.getBody().get();
    
    result = CustomVisionService.classifyRest(logger, image);
      
    return request.createResponseBuilder(HttpStatus.OK).body("Prediction result: " + result).build();
  }

}
