package com.breitenbaumer.shared;

import java.util.List;
import java.util.UUID;

import com.azure.core.http.HttpClient;
import com.azure.core.http.HttpMethod;
import com.azure.core.http.HttpRequest;
import com.azure.core.http.HttpResponse;
import com.azure.core.http.netty.NettyAsyncHttpClientBuilder;
import com.azure.core.util.UrlBuilder;

import com.microsoft.azure.cognitiveservices.vision.customvision.prediction.CustomVisionPredictionClient;
import com.microsoft.azure.cognitiveservices.vision.customvision.prediction.CustomVisionPredictionManager;
import com.microsoft.azure.cognitiveservices.vision.customvision.prediction.models.ImagePrediction;
import com.microsoft.azure.cognitiveservices.vision.customvision.prediction.models.Prediction;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.CustomVisionTrainingClient;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.CustomVisionTrainingManager;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.models.Iteration;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.models.Project;

import java.util.logging.Level;
import java.util.logging.Logger;

public class CustomVisionService {
        public static String classify(Logger logger, byte[] image) {
                String result = "";

                String trainingEndpoint = System.getenv("CUSTOM_VISION_TRAINING_ENDPOINT");
                logger.info("trainingEndpoint: " + trainingEndpoint);
                String trainingApiKey = System.getenv("CUSTOM_VISION_TRAINING_KEY");
                logger.info("trainingApiKey size: " + trainingApiKey.length());
                String predictionEndpoint = System.getenv("CUSTOM_VISION_PREDICTION_ENDPOINT");
                logger.info("predictionEndpoint: " + predictionEndpoint);
                String predictionApiKey = System.getenv("CUSTOM_VISION_PREDICTION_KEY");
                logger.info("predictionApiKey size: " + predictionApiKey.length());

                // init custom service
                CustomVisionTrainingClient trainer = CustomVisionTrainingManager
                                .authenticate(trainingEndpoint, trainingApiKey)
                                .withEndpoint(trainingEndpoint);
                CustomVisionPredictionClient predictor = CustomVisionPredictionManager
                                .authenticate(predictionEndpoint, predictionApiKey)
                                .withEndpoint(predictionEndpoint);

                List<Project> projects = trainer.trainings().getProjects();
                if (null == projects || projects.size() == 0) {
                        return "No projects found.";
                } else {
                        logger.info("Found " + projects.size() + " projects.");
                        UUID projectId = projects.get(0).id();
                        logger.info("Using project " + projectId);
                        List<Iteration> iterations = trainer.trainings().getIterations(projectId);
                        logger.info("Found " + iterations.size() + " iterations.");
                        if (iterations.size() == 0) {
                                return "No iterations found.";
                        } else {
                                String publishName = iterations.get(iterations.size() - 1).publishName();
                                // predict
                                ImagePrediction results = predictor
                                                .predictions()
                                                .classifyImage()
                                                .withProjectId(projectId)
                                                .withPublishedName(publishName)
                                                .withImageData(image)
                                                .execute();

                                for (Prediction prediction : results.predictions()) {
                                        result += String.format("\t%s: %.2f%%", prediction.tagName(),
                                                        prediction.probability() * 100.0f)
                                                        + System.lineSeparator();
                                }
                                return result;
                        }
                }
        }

        public static String classifyRest(Logger logger, byte[] image) {
                try {
                        HttpClient httpClient = new NettyAsyncHttpClientBuilder().build();

                        String predictionEndpoint = System.getenv("CUSTOM_VISION_PREDICTION_ENDPOINT");
                        logger.info("predictionEndpoint: " + predictionEndpoint);
                        String predictionApiKey = System.getenv("CUSTOM_VISION_PREDICTION_KEY");
                        logger.info("predictionApiKey size: " + predictionApiKey.length());
                        String predictionPath= System.getenv("CUSTOM_VISION_PREDICTION_PATH");
                        logger.info("predictionApiKey size: " + predictionApiKey.length());

                        UrlBuilder builder = new UrlBuilder().setHost(predictionEndpoint.replace("https://", "").replace("/", ""));
                        builder.setPath(predictionPath);
                        builder.setScheme("https");
                        HttpRequest request = new HttpRequest(HttpMethod.POST, builder.toUrl());

                        // Request headers.
                        request.setHeader("Content-Type", "application/octet-stream");
                        request.setHeader("Prediction-Key", predictionApiKey);

                        request.setBody(image);

                        // Call the REST API method and get the response entity.
                        HttpResponse response = httpClient.send(request).block();
                        if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                                logger.log(Level.INFO,
                                                "Request successful with status code " + response.getStatusCode());
                                String responseBody = response.getBodyAsString().block();
                                logger.log(Level.INFO, "Response body: " + responseBody);
                                return responseBody;
                        } else {
                                logger.log(Level.WARNING,
                                                "Request NOT successful with status code " + response.getStatusCode());
                                String responseBody = response.getBodyAsString().block();
                                logger.log(Level.WARNING, "Response body: " + responseBody);
                                return responseBody;
                        }
                } catch (Exception e) {
                        return e.getMessage();
                }

        }
}
