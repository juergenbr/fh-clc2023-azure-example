package com.breitenbaumer.shared;

import java.util.logging.Level;
import java.util.logging.Logger;

import com.azure.core.http.HttpClient;
import com.azure.core.http.HttpMethod;
import com.azure.core.http.HttpRequest;
import com.azure.core.http.HttpResponse;
import com.azure.core.http.netty.NettyAsyncHttpClientBuilder;
import com.azure.core.util.UrlBuilder;

public class CognitiveServiceClientProvider {
    private Logger logger;
    // TODO: (1) define strings for endpoint, subscription key and endpointPath

    public CognitiveServiceClientProvider(Logger logger) {
        this.logger = logger;
    }

    /**
     * Sends REST request to Computer vision endpoint and returns result
     * @urlToImage publically reachable URL to the image that whould be analyzed
     * @return JSON string of the analysis result
     * @see https://docs.microsoft.com/en-us/rest/api/computervision/3.1/analyze-image/analyze-image?tabs=HTTP
     **/
    public String sendRequest(String urlToImage) {
        HttpClient httpClient = new NettyAsyncHttpClientBuilder().build();

        try {
            UrlBuilder builder = new UrlBuilder().setHost(endpoint);

            // TODO: (2) set request parameters for image analysis depending on what you want to analyze
            
            // TODO: (3) build the URL path
            
            builder.setScheme("https");
            HttpRequest request = new HttpRequest(HttpMethod.POST, builder.toUrl());

            // Request headers.
            request.setHeader("Content-Type", "application/json");
            request.setHeader("Ocp-Apim-Subscription-Key", System.getenv(subscriptionKeyEnvVarName));

            request.setBody("{\"url\":\"" + urlToImage + "\"}");

            // Call the REST API method and get the response entity.
            HttpResponse response = httpClient.send(request).block();
            if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                logger.log(Level.INFO, "Request successful with status code " + response.getStatusCode());
                String responseBody = response.getBodyAsString().block();
                logger.log(Level.INFO, "Response body: " + responseBody);
                return responseBody;
            } else {
                logger.log(Level.WARNING, "Request NOT successful with status code " + response.getStatusCode());
                logger.log(Level.WARNING, "Response body: " + response.getBodyAsString().block());
            }
        } catch (Exception e) {
            // Display error message.
            System.out.println(e.getMessage());
        }
        return "";
    }
}
