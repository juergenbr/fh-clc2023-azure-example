package com.breitenbaumer.shared;

import java.util.List;
import java.util.UUID;

import com.microsoft.azure.cognitiveservices.vision.customvision.prediction.CustomVisionPredictionClient;
import com.microsoft.azure.cognitiveservices.vision.customvision.prediction.CustomVisionPredictionManager;
import com.microsoft.azure.cognitiveservices.vision.customvision.prediction.models.ImagePrediction;
import com.microsoft.azure.cognitiveservices.vision.customvision.prediction.models.Prediction;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.CustomVisionTrainingClient;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.CustomVisionTrainingManager;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.models.Iteration;
import com.microsoft.azure.cognitiveservices.vision.customvision.training.models.Project;

public class CustomVisionService {
    public static String classify(byte[] image) {
        String result = "";

        String trainingEndpoint = System.getenv("CUSTOM_VISION_TRAINING_ENDPOINT");
        String trainingApiKey = System.getenv("CUSTOM_VISION_TRAINING_KEY");
        String predictionEndpoint = System.getenv("CUSTOM_VISION_PREDICTION_ENDPOINT");
        String predictionApiKey = System.getenv("CUSTOM_VISION_PREDICTION_KEY");

        // init custom service
        CustomVisionTrainingClient trainer = CustomVisionTrainingManager
                .authenticate(trainingEndpoint, trainingApiKey)
                .withEndpoint(trainingEndpoint);
        CustomVisionPredictionClient predictor = CustomVisionPredictionManager
                .authenticate(predictionEndpoint, predictionApiKey)
                .withEndpoint(predictionEndpoint);

        List<Project> projects = trainer.trainings().getProjects();
        UUID projectId = projects.get(0).id();
        List<Iteration> iterations = trainer.trainings().getIterations(projectId);
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
            result += String.format("\t%s: %.2f%%", prediction.tagName(), prediction.probability() * 100.0f)
                    + System.lineSeparator();
        }
        return result;
    }

}
