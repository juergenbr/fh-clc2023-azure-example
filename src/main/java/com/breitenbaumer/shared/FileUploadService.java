package com.breitenbaumer.shared;

import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;

import com.azure.core.util.BinaryData;
import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.models.UserDelegationKey;
import com.azure.storage.blob.sas.BlobContainerSasPermission;
import com.azure.storage.blob.sas.BlobServiceSasSignatureValues;

public class FileUploadService {

    private Logger logger;
    private BlobClientProvider provider;
    private BlobServiceClient blobServiceClient;
    private BlobContainerClient imageContainer;
    private BlobContainerClient resultContainer;
    private static String imagecontainerName = System.getenv("CONTAINERNAME");
    private static String resultscontainerName = System.getenv("RESULTSCONTAINERNAME");

    public FileUploadService(Logger logger) {
        this.logger = logger;
        this.provider = new BlobClientProvider(logger);
        this.blobServiceClient = provider.getBlobServiceClient();
        this.imageContainer = blobServiceClient.createBlobContainerIfNotExists(imagecontainerName);
        this.resultContainer = blobServiceClient.createBlobContainerIfNotExists(resultscontainerName);
    }

    public String upload(byte[] content, String fileName) {
        try {
            BlobClient blobClient;
            if(fileName.endsWith(".json")){
                blobClient = provider.getBlobClient(resultContainer.getBlobContainerName(), fileName);
            }
            else{
                blobClient = provider.getBlobClient(imageContainer.getBlobContainerName(), fileName);
            }
            logger.info("\n\tUploading" + fileName + " to container " + blobClient.getContainerName());
            blobClient.upload(BinaryData.fromBytes(content), true);
            logger.info("\t\tSuccessfully uploaded the blob.");
            return blobClient.getBlobUrl();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed uploading file.", e.fillInStackTrace());
        }
        return "";
    }

    // extracts file name from a multipart boundary
    public String getFileName(Map<String, String> headers) {
        if (headers.containsKey("FileName")) {
            return headers.get("FileName");
        } else {
            return "image_" + LocalDate.now().getYear() + "-" + LocalDate.now().getMonthValue() + "-"
                    + LocalDate.now().getDayOfMonth() + "_" + LocalDateTime.now().getHour() + "-"
                    + LocalDateTime.now().getMinute() + "-" + LocalDateTime.now().getSecond() + ".jpg";
        }
    }

    public String generateUserDelegationSASToken(String fileName) {
        try{
            OffsetDateTime keyStart = OffsetDateTime.now();
            OffsetDateTime keyExpiry = OffsetDateTime.now().plusMinutes(5);
            BlobClient blobClient = provider.getBlobClient(imageContainer.getBlobContainerName(), fileName);
            UserDelegationKey userDelegationKey = blobServiceClient.getUserDelegationKey(keyStart, keyExpiry);
    
            BlobContainerSasPermission blobContainerSas = new BlobContainerSasPermission();
            blobContainerSas.setReadPermission(true);
            BlobServiceSasSignatureValues blobServiceSasSignatureValues = new BlobServiceSasSignatureValues(keyExpiry,
                    blobContainerSas);
    
            String sas = blobClient.generateUserDelegationSas(blobServiceSasSignatureValues, userDelegationKey);
            //logger.info("SAS: " + sas);
            return sas;
        }
        catch(Exception e){
            logger.log(Level.SEVERE, "Failed generating SAS token.", e.fillInStackTrace());
        }
        return "";
    }
}