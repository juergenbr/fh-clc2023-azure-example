package com.breitenbaumer.shared;

import com.azure.identity.DefaultAzureCredential;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobClientBuilder;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;

import java.util.logging.Logger;

/**
 * @apiNote Code from link
 *          https://github.com/Azure-Samples/storage-blob-java-getting-started/blob/master/src/BlobClientProvider.java
 */
public class BlobClientProvider {

  private String storageAccountUrl = "https://" + System.getenv("STORAGEACCOUNT_NAME") + ".blob.core.windows.net/";
  private DefaultAzureCredential defaultCredential;
  private Logger logger;

  public BlobClientProvider(Logger logger) {
    this.defaultCredential = new DefaultAzureCredentialBuilder().build();
    this.logger = logger;
    logger.info("\n\tDefaultAzureCredential created.");
  }

  /*
   * Create new BlobServiceClient using ManagedIdentity authentication.
   */
  public BlobServiceClient getBlobServiceClient() {
    logger.info("Trying to connect to storage account " + storageAccountUrl);
    BlobServiceClient client = new BlobServiceClientBuilder()
        .endpoint(storageAccountUrl)
        .credential(this.defaultCredential)
        .buildClient();
    return client;
  }

  /*
   * Create new BlobClient using ManagedIdentity authentication.
   */
  public BlobClient getBlobClient(String containerName, String blobName) {
    BlobClient client = new BlobClientBuilder()
        .endpoint(storageAccountUrl)
        .containerName(containerName)
        .blobName(blobName)
        .credential(this.defaultCredential)
        .buildClient();
    return client;
  }

}
