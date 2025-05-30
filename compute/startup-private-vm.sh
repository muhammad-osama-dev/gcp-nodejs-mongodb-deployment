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



# setup github actions runner

useradd -m -s /bin/bash github-runner


GITHUB_PAT=$(gcloud secrets versions access latest --secret=github-pat)
GITHUB_ORG="muhammad-osama-dev"
GITHUB_REPO="gcp-nodejs-mongodb-deployment"  
RUNNER_VERSION="2.324.0"
RUNNER_DIR="/home/github-runner/actions-runner"

echo $GITHUB_PAT >> tracker.txt
echo "Installing GitHub Actions Runner ..." >> tracker.txt


TOKEN=$(curl -s -X POST -H "Authorization: token $GITHUB_PAT" "https://api.github.com/repos/$GITHUB_ORG/$GITHUB_REPO/actions/runners/registration-token" | jq -r '.token')

sudo -u github-runner bash <<EOF
set -e
mkdir -p $RUNNER_DIR
cd $RUNNER_DIR

# Download and extract
curl -o actions-runner-linux-x64-2.324.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.324.0/actions-runner-linux-x64-2.324.0.tar.gz
tar xzf actions-runner-linux-x64-2.324.0.tar.gz

# Configure and start
./config.sh --url https://github.com/$GITHUB_ORG/$GITHUB_REPO --token $TOKEN --unattended
nohup ./run.sh > runner.log 2>&1 &
EOF

echo "GitHub runner setup complete." >> /var/log/startup-script.log

EOF

