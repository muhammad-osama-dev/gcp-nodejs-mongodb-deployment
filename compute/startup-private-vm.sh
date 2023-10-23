#!/bin/bash

################## setting up Docker ####################
# Add Docker's official GPG key:
cd / 
echo "Installing Docker ..." >> tracker.txt
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y



################# Authinticating Docker ##################
cd /tmp
sudo wget --header="Metadata-Flavor: Google" -O key.json http://metadata.google.internal/computeMetadata/v1/instance/attributes/sa_key
cat key.json | base64 -d > key1.json
gcloud auth activate-service-account --key-file=key1.json
yes | gcloud auth configure-docker us-east1-docker.pkg.dev 
cat key.json | sudo docker login -u _json_key_base64 --password-stdin https://us-east1-docker.pkg.dev
cd /


################ App Image ###################
echo "Pulling app image ..." >> tracker.txt
sudo docker pull moelshafei/nodeapp:latest
echo "Image Pulled ..." >> tracker.txt
sudo docker tag moelshafei/nodeapp:latest us-east1-docker.pkg.dev/${VAR1_project_id}/${VAR2_repo_id}/app:latest
sudo docker push us-east1-docker.pkg.dev/${VAR1_project_id}/${VAR2_repo_id}/app:latest
echo "Image Pushed" >> tracker.txt


############# MongoDB Image ####################
echo "Pulling mognodb image ..." >> tracker.txt
sudo docker pull bitnami/mongodb:4.4.4
echo "Pulled mognodb image ..." >> tracker.txt
sudo docker tag bitnami/mongodb:4.4.4 us-east1-docker.pkg.dev/${VAR1_project_id}/${VAR2_repo_id}/mongodb:latest
echo "Pushing mognodb image ..." >> tracker.txt
sudo docker push us-east1-docker.pkg.dev/${VAR1_project_id}/${VAR2_repo_id}/mongodb:latest
echo "Image Pushed ..." >> tracker.txt




###### For proxy ################
sudo apt-get install kubectl
echo "kubectl installed ..." >> tracker.txt
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
echo "google auth ..." >> tracker.txt
export KUBECONFIG=$HOME/.kube/config
gcloud container clusters get-credentials ${VAR4_cluster_name} --zone ${VAR3_cluster_region} --project ${VAR1_project_id} --internal-ip
gcloud container clusters update ${VAR4_cluster_name} --zone ${VAR3_cluster_region}  --enable-master-global-access
sudo apt install tinyproxy -y
echo "tiny proxy installed ..." >> tracker.txt
sudo sh -c "echo 'Allow localhost' >> /etc/tinyproxy/tinyproxy.conf"
sudo service tinyproxy restart
echo "service restarted auth ..." >> tracker.txt
exit


# You can use that if you want to pull kubernetes files and apply them automatically (not secure) 
############ cloning the kubernetes files ############
# cd /
# sudo apt-get install git-all
# git clone https://github.com/muhammad-osama-dev/gcp-nodejs-mongodb-deployment.git
# cd /gcp-nodejs-mongodb-deployment
# sudo apt-get install kubectl
# echo "kubectl installed ..." >> tracker.txt
# sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
# echo "google auth ..." >> tracker.txt
# export KUBECONFIG=$HOME/.kube/config
# gcloud container clusters get-credentials gke-cluster --zone=us-central1 > output.txt 2>&1
# echo "cluster auth ..." >> tracker.txt
# kubectl apply -f ./kubernetes/mongodb/
# echo "mongodb deployed ..." >> tracker.txt
# kubectl apply -f ./kubernetes/app_deployment/
# echo "app deployed ..." >> tracker.txt
EOF

