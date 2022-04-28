# Provisioning Lab

## Quick-start Instructions

1. Launch Azure Cloud Shell (bash) from Azure Portal  [Azure Cloud Shell](https://shell.azure.com/bash) using the link https://shell.azure.com/bash.
2. Setup Git in Cloud Shell
    ```bash
    git config --global --unset credential.helper
    git config --global credential.helper store
    git config --global user.name "<YourName>"
    git config --global user.email <YourAlias>@gourav.com
    ```
3. Clone the Cloud_DevOps repo. *Password (if prompted) is available by clicking Generate Credential under Clone for this repo.
    ```bash
    git clone https://Test-Developer-Services@dev.azure.com/Test-Developer-Services/Cloud_DevOps/_git/Cloud_DevOps
    ```
4. Pull the latest changes to the repo (as required - recommended to stay current):
   ```bash
   cd ~/Cloud_DevOps
   git pull
   ```
5. Deplopy a new lab using the following commands:
   ```bash
    az account set -s 'Gourav-test-az-subscription'
	az deployment group create -g <RgName> --template-file "~/Cloud_DevOps/ProvisionLab/azuredeploy.json" --parameters newLabName=<labName>
    ```
	Where,
    * `<LabName>` - Name of the Lab to be created, dtl-<userId>-<number e.g. 001>
    * `<RgName>` - Name for the new resource group where the lab will be created
    * Optional parameters:
    ```bash
    CuratedMarketplace=<true or false(default)>
    artifactRepoSecurityToken=<Git Credential>
    ```
	
	For example:
	```bash
	az deployment group create -g rg-dtl-dev --template-file "~/Cloud_DevOps/ProvisionLab/azuredeploy.json" --parameters newLabName=dtl-gravenc2-001
    ```


## About the resources created in the Lab
The ARM template creates a demo lab with the following things:
* It sets up all the policies, private networking, and Enables Public Environment artifacts repo.

You can update the Lab settings by re-executing the az deployment cmdlet with the lab name and optional parameters.

## Dependancy (already setup)
For the lab to connect to DevOps Repo it requires a Git Credential - this will be stored in a Keyvault in the same resource group as the labs are deployed to

Deploy keyvault and add your secret from the "Generate Git credentials button" in Azure DevOps
```bash
az keyvault create -g rg-dtl-dev-cac --name dtldevcac --enabled-for-template-deployment true --enable-rbac-authorization
az role assignment create --role "Key Vault Reader (preview)" --assignee {i.e user@microsoft.com} --scope /subscriptions/{subscriptionid}/resourcegroups/{resource-group-name}
az keyvault secret set -g rg-dtl-dev-cac --vault-name dtldevcac --name "AzureDevOpsReposCredential" --value "<Git Credential>"
```
