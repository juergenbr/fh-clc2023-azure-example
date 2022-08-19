# fh-clc2022-azure-example
[![Build and deploy Java project to Azure Function App](https://github.com/juergenbr/fh-clc2022-azure-example/actions/workflows/master_fh-clc3-2wlkaldek525w.yml/badge.svg?branch=master)](https://github.com/juergenbr/fh-clc2022-azure-example/actions/workflows/master_fh-clc3-2wlkaldek525w.yml)

# Setup

## Infrastructure Deployment
1) fork the example respository
2) check out your own repo
3) Open Terminal in the repo root folder
4) execute `cd ./infrastructure`
5) execute `az login` and log in to your Azure Free Trial account
6) execute `az account set --subscription <your subscription name>`
7) execute `az deployment sub create --template-file main.bicep --location WestEurope`
   - The deployment will ask for the following values:
     - 'deploymentName': free choosable name for the deployment (e.g. `clc3-example`)
     - 'rgName': name of the resource group which should be created for the deployment (e.g. `rg-clc3-example`)
     - 'location': region where the infrastructure should be created (e.g. `westeurope`)

---
## Function deployment
If the above deployment worked without errors you can deploy the function code as a next step.

1. Open the Azure portal (portal.azure.com) and navigate to the resource group created in the previous step.
2. Find the resource of type `Function App`in the list, click on the name and open the menu entry `Deployment Center`in the left-hand menu.

3. If there is already a GitHub connection, press "Disconnect" under Source
4. Set up a new connection to Github
   - Organization: should be same as your GitHub user
   - Repository: the forked repository from the infrastrcture setup
   - Branch: master
   - Build provider: GitHub Actions
   - Runtime stack: Java
   - Version: 11
5. Click `Save`. This will automatically add a new GitHub Actions workflow to your repository and trigger a build that should deploy your function. Chekc the status in the `Actions` tab in your GitHub repository.
6. Validate that the deployment worked. Find the resource of type `Function App`in the list, click on the name and open the menu entry `Functions` in the left-hand menu. You should see one entry with name `blobStorageUpload`, Trigger `HTTP` and Status `Enabled`

At this point, your function should be ready to upload an image to the blob storage. What's missing now is the configuration of the Logic App that get's triggered after a new file is added to the blob container and sends it to the Computer Vision service for analysis.

---
## Logic App Setup
1. Find the Logic App in your resource group named `fh-clc3-logicapp` and open it.
2. Click the `Edit` button in the top menu
3. Edit the steps marked with an exclamation mark. Those steps require a connection configuration to communicate the the underlying  Azure Services (Storage Account and Congitive Service).
4. **TODO: add screenshots and how-to**
