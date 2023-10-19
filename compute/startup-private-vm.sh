#!/bin/bash
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



sudo apt-get install git-all
git clone https://github.com/Mostafa-Yehia/simple-node-app.git

# sudo apt install npm -y
cd simple-node-app
cat > Dockerfile <<EOF
# Use an official Node.js runtime as the base image
FROM node:latest

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY . /app

# Install application dependencies
RUN npm i

# Expose a port for the application to listen on
EXPOSE 8080

# Define the command to start your application
CMD [ "node", "index.js" ]
EOF

# sudo docker build -t us-east1-docker.pkg.dev/itisv-401212/test/app:latest .
# sudo docker push us-east1-docker.pkg.dev/itisv-401212/test/app:latest

EOF

