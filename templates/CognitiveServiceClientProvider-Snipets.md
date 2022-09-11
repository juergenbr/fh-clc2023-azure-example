1) define endpoint strings
```
private String endpoint = "westeurope.api.cognitive.microsoft.com";
private String subscriptionKeyEnvVarName = "SUBSCRIPTIONKEY";
private String endpointPath = "vision/v3.2/analyze";
```
// (2) set request parameters for image analysis depending on what you want to analyze
```
String requestParameters = "visualFeatures=Adult,Brands,Categories,Color,Description,Faces,ImageType,Objects,Tags";
```
// (3) build the URL path
```
builder.setPath(endpointPath + "?" + requestParameters);
```