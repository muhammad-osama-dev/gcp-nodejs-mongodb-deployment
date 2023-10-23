# Infrastructure as Code with Terraform on Google Cloud Platform (GCP)

This project demonstrates how to create a robust infrastructure on Google Cloud Platform using Terraform modules. The infrastructure includes IAM settings, a network setup, compute resources, and a MongoDB replica set, along with a Node.js web app that connects to the database. The web app is exposed using an ingress/load balancer. Here's a step-by-step guide on how to use this repository to set up your own infrastructure.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Terraform Modules](#terraform-modules)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

Before you begin, make sure you have the following tools and resources set up:

- [Terraform](https://www.terraform.io/) installed.
- [Google Cloud SDK](https://cloud.google.com/sdk) installed and configured.
- A Google Cloud Platform (GCP) account with billing enabled and a Project.
- A GitHub account for version control (optional but recommended).

## Getting Started

Clone this repository to your local environment to start setting up the infrastructure.

```bash
git clone https://github.com/muhammad-osama-dev/gcp-nodejs-mongodb-deployment.git
cd gcp-nodejs-mongodb-deployment
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

### Terraform Modules

I've organized the infrastructure as code into Terraform modules for easier management and reusability. In the modules directory, you will find modules for IAM, network, compute, and storage. Customize the input variables such as project_id(use your project id), region1(cluster region), region2(managment vm region), vpc name .. etc in the terraform.tfvars file in the root directory to match your requirements

## Usage

make sure you are in gcp-nodejs-mongodb-deployment directory 

apply infrastructure using terraform

```bash
terraform apply 
```
takes around 20-40m to apply so play chess game or something 

after applying you can check progress through managment vm 
ssh to the machine using gcloud and iap

```bash
gcloud compute ssh my-private-instance --zone=us-east1-b --tunnel-through-iap --project=PROJECT_ID
```
these are the default vales if you changed the variables adjust according to that 

```bash
watch cat /tracker.txt
```


