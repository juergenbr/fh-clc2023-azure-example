package com.breitenbaumer;

public class Function {

  private Logger logger;

  @FunctionName("blobStorageUpload")
  public HttpResponseMessage run(
    /*
     * Function header
     * Trigger: HTTP
     * Input: binary array, Context
     * Authentication: Function Key
     */
  ) throws Exception {

    // TODO: (1) init upload service

    // TODO: (2) upload image
    
    // TODO: (3) generate SAS token and url

    // TODO: (4) send image to cognitive service and upload result as JSON
    
    // TODO: (5) return response

  }

}
