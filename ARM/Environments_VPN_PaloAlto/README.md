# Azure DevTest Labs Environments

This folder represents the Azure DevTest Labs Public Environment Repo, as shown in the Azure Portal.

For information about [environments](https://docs.microsoft.com/en-us/azure/lab-services/devtest-lab-concepts#environment) and how they can be leveraged in Azure DevTest Labs, refer to [Configure and use public environments in Azure DevTest Labs](https://docs.microsoft.com/en-us/azure/lab-services/devtest-lab-configure-use-public-environments).

## AKS
1. Using Add select 'Kubernetes (AKS) using Managed Identity'
2. Set the name of the 'Environment Name' e.g. AKSLab1, and click 'Add' to deploy
3. Once finished provisioning click on the Environment and then make node of the Resource Group name, and AKS Cluster name
4. Install Kubectl (not required if executing inside Azure CloudShell)
```bash
az aks install-cli
```
5. Get the Cluster credentials
```bash
az aks get-credentials --admin --resource-group <ResourceGroupName> --name <ClusterName>
```
6. Execute Cluster commands:
```bash
kubectl get nodes
```

### Web App
Notes:
Reusing an App Service Plan
* Look for the Resource Id of an existing plan under the resources properties (in the Portal) and copy / paste that into the 'ExitingAppServicePlanResourceId' field when creating a new Web App

Azure AD [Authentication](https://docs.microsoft.com/en-us/azure/app-service/configure-authentication-provider-aad#advanced). 
To avoid being prompted 'Approval required':
* Under the App Identity, under Expose an API, under Scope, I set my "Who can consent?" to "Admins and users" (default is "admins")
* In App Service, under Authentication, Active Directory Authentication, Issuer Url: https://login.microsoft.com/XXXXXXXXXXX

## Contributions

Contributions to the Public Environment Repo are limited to corrections in the existing code base. At times, new environments will be welcome. However, the team reserves the right to decide which contributions will be accepted.

The process to get changes published requires the team to review the code submissions and test the environment contributions or the changes. Submit a pull request to get the process started.

### Submission Requirements

Create a pull request that includes
* __a single environment per pull request__,
* a detailed description of the new contribution or the change,
* steps on how to test the environment and/or changes,
* screenshots of the expected output, where possible, from your own testing, and
* a top level `README.md` document with details about the environment (for new contributions).
