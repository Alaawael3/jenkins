#!bin/bash

sudo apt update 

sudo apt install openjdk-8-jdk -y

https://pkg.jenkins.io/debian-stable/
# when goin to the above link, it will show you the command to add the jenkins repository to your system. It will be something like below
# sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
# https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

# echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
    # https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    # /etc/apt/sources.list.d/jenkins.list > /dev/null
# sudo apt-get update
# sudo apt-get install fontconfig openjdk-21-jre
# sudo apt-get install jenkins


# then 

sudo systemctl start jenkins

sudo systemctl enable jenkins

sudo systemctl status jenkins # run jenkins to ensure its right and ctrl+c



## Installing Docker

curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

sudo usermod -aG docker $USER

sudo usermod -aG docker jenkins


newgrp docker


sudo apt install awscli -y #if not working
sudo apt-get remove awscli -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws --version


sudo usermod -a -G docker jenkins


## AWS configuration 
aws configure
## & restarts jenkins by restarting the instance on AWS
# then check
sudo systemctl status jenkins

## Now setup elastic IP on AWS



## For getting the admin password for jenkins

sudo cat /var/lib/jenkins/secrets/initialAdminPassword