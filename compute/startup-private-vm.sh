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

# gcloud auth configure-docker -y

######################### pulling application ##########################
sudo apt-get install git-all
git clone https://github.com/Mostafa-Yehia/simple-node-app.git

# sudo apt install npm -y
##################### Dockeraizing Application ########################
cd /simple-node-app
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
cd /simple-node-app

################ App Image ###################
echo "Pulling app image ..." >> tracker.txt
sudo docker pull moelshafei/nodeapp:latest
echo "Image Pulled ..." >> tracker.txt
sudo docker tag moelshafei/nodeapp:latest us-east1-docker.pkg.dev/itisv-401212/private-vm-repo/app:latest
# sudo docker build -t us-east1-docker.pkg.dev/itisv-401212/private-vm-repo/app:latest .
sudo docker push us-east1-docker.pkg.dev/itisv-401212/private-vm-repo/app:latest
echo "Image Pushed" >> tracker.txt
############# MongoDB Image ####################
echo "Pulling mognodb image ..." >> tracker.txt
sudo docker pull bitnami/mongodb:4.4.4
echo "Pulled mognodb image ..." >> tracker.txt
sudo docker tag bitnami/mongodb:4.4.4 us-east1-docker.pkg.dev/itisv-401212/private-vm-repo/mongodb:latest
echo "Pushing mognodb image ..." >> tracker.txt
sudo docker push us-east1-docker.pkg.dev/itisv-401212/private-vm-repo/mongodb:latest
echo "Image Pushed ..." >> tracker.txt




############ cloning the kubernetes files ############
cd /
git clone https://muhammad-osama-dev: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@github.com/muhammad-osama-dev/gcp-nodejs-mongodb-deployment.git
cd /gcp-nodejs-mongodb-deployment
gcloud container clusters get-credentials gke-cluster --zone=us-central1
kubectl apply -f ./kubernetes/mongodb/
kubectl apply -f ./kubernetes/app_deployment/
EOF

