#!/bin/bash

################## setting up Docker ####################
# Add Docker's official GPG key:
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


######################### pulling application ##########################
# sudo apt-get install git-all

# sudo apt install npm -y
##################### Dockeraizing Application ########################
# cat > Dockerfile <<EOF
# # Use an official Node.js runtime as a parent image
# FROM node:18

# # Set the working directory in the container
# WORKDIR /usr/src/app

# # Copy package.json and package-lock.json to the working directory
# COPY package*.json ./

# # Install application dependencies
# RUN npm install

# # Bundle app source
# COPY . .

# # Expose the port your application runs on
# EXPOSE 5000

# # Define the command to run your application
# CMD ["node", "index.js"]
# EOF
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
sudo docker tag moelshafei/nodeapp:latest us-east1-docker.pkg.dev/halogen-data-401020/private-vm-repo/app:latest
# sudo docker build -t us-east1-docker.pkg.dev/itisv-401212/private-vm-repo/app:latest .
sudo docker push us-east1-docker.pkg.dev/halogen-data-401020/private-vm-repo/app:latest
echo "Image Pushed" >> tracker.txt
############# MongoDB Image ####################
echo "Pulling mognodb image ..." >> tracker.txt
sudo docker pull bitnami/mongodb:4.4.4
echo "Pulled mognodb image ..." >> tracker.txt
sudo docker tag bitnami/mongodb:4.4.4 us-east1-docker.pkg.dev/halogen-data-401020/private-vm-repo/mongodb:latest
echo "Pushing mognodb image ..." >> tracker.txt
sudo docker push us-east1-docker.pkg.dev/halogen-data-401020/private-vm-repo/mongodb:latest
echo "Image Pushed ..." >> tracker.txt




###### For proxy ################
sudo apt-get install kubectl
echo "kubectl installed ..." >> tracker.txt
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
echo "google auth ..." >> tracker.txt
export KUBECONFIG=$HOME/.kube/config
gcloud container clusters get-credentials gke-cluster --zone us-central1 --project halogen-data-401020 --internal-ip
gcloud container clusters update gke-cluster --zone us-central1  --enable-master-global-access
sudo apt install tinyproxy -y
echo "tiny proxy installed ..." >> tracker.txt
sudo sh -c "echo 'Allow localhost' >> /etc/tinyproxy/tinyproxy.conf"
sudo service tinyproxy restart
echo "service restarted auth ..." >> tracker.txt
exit

############ cloning the kubernetes files ############
cd /
# git clone https://muhammad-osama-dev:token@github.com/muhammad-osama-dev/gcp-nodejs-mongodb-deployment.git
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

