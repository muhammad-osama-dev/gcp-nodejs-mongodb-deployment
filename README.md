# Infrastructure as Code with Terraform on Google Cloud Platform (GCP)

This branch (`feature/scale-down`) contains a **scaled down** version of the main infrastructure repository for deploying a simple Node.js application on Google Cloud Platform (GCP).


## Overview

The scaled down branch simplifies the full deployment by focusing on a smaller, more manageable infrastructure.

Key differences from the main branch:

- Reduced number gke nodes.
- Designed for use with a **private VM acting as a GitHub self-hosted runner**.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Terraform Modules](#terraform-modules)
- [Usage](#usage)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

Before you begin, make sure you have the following tools and resources set up:

- [Terraform](https://www.terraform.io/) installed.
- [Google Cloud SDK](https://cloud.google.com/sdk) installed and configured.
- A Google Cloud Platform (GCP) account with billing enabled and a Project.
- A GitHub account for version control (optional but recommended).
- Github personal access token 

## Getting Started

Clone this repository to your local environment to start setting up the infrastructure.

```bash
git clone https://github.com/muhammad-osama-dev/gcp-nodejs-mongodb-deployment.git
cd gcp-nodejs-mongodb-deployment
git checkout feature/scale-down
```
Install Google Cloud SDK if you haven't already

```bash
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
gcloud auth login
gcloud projects list
gcloud config set project PROJECT_ID
```

Create a Service account for terraform through gcloud or console 

```bash
gcloud iam service-accounts create SERVICE_ACCOUNT_NAME --display-name "DISPLAY_NAME"
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID --member=serviceAccount:SERVICE_ACCOUNT_EMAIL --role=roles/editor
```
For example

```bash
gcloud iam service-accounts create SERVICE_ACCOUNT_NAME --display-name "my-service-account"
gcloud projects add-iam-policy-binding my-gcp-project --member=serviceAccount:my-service-account@my-gcp-project.iam.gserviceaccount.com --role=roles/editor
```
Create a key for the service account 

```bash
gcloud iam service-accounts keys create KEY_FILE.json --iam-account SERVICE_ACCOUNT_EMAIL
```
put your key path in the main.tf file in the cloud provider block 

Create a Github Personal Access token

Store it in gcp access manager 

```bash
gcloud services enable secretmanager.googleapis.com
echo -n "YOUR_GITHUB_TOKEN" | gcloud secrets create github-pat --data-file=-
```

To change the runner's organization and repository, edit the startup-private-vm.sh script (the runner will be configured on the repository level):

```bash
GITHUB_ORG="muhammad-osama-dev"
GITHUB_REPO="ci-cd-nodejs"
```

### Terraform Modules

I've organized the infrastructure as code into Terraform modules for easier management and reusability. In the modules directory, you will find modules for IAM, network, compute, and storage. Customize the input variables such as project_id(use your project id), region1(cluster region), region2(managment vm region), vpc name .. etc in the terraform.tfvars file in the root directory to match your requirements

## Usage

make sure you are in gcp-nodejs-mongodb-deployment directory 

apply infrastructure using terraform

```bash
terraform init
terraform apply 
```
takes around 20m 

after applying you can check progress through managment vm 
ssh to the machine using gcloud and iap

```bash
gcloud compute ssh my-private-instance --zone=us-east1-b --tunnel-through-iap --project=PROJECT_ID
```
these are the default vales if you changed the variables adjust according to that 

```bash
watch cat /tracker.txt
```
wait till it looks something like that

```bash
Installing Docker ...
kubectl installed ...
google auth ...
tiny proxy installed ...
service restarted auth ...
```

The private VM will automatically set up the GitHub self-hosted runner using the startup script.

in the startup-private-vm

## Cleanup
To delete the resources and clean up your GCP project:

Run the following Terraform command to destroy the infrastructure:
```bash
terraform destroy
```
When prompted, confirm that you want to destroy the resources.
This will remove all the resources created by Terraform. Be cautious, as this action is irreversible.

Optionally, delete the service account and associated key, if no longer needed:
```bash
gcloud iam service-accounts delete SERVICE_ACCOUNT_EMAIL
```
Don't forget to delete the GCP project if you created a separate one for this project.

Happy cloud adventures 😊🚀


## 📄 License

MIT License.

---

## 🙋‍♂️ Author

Muhammad Osama – https://github.com/muhammad-osama-dev



