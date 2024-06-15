#!/bin/bash

########################
# Installing Jenkins   #
########################
apt-get  update -y

apt-get install docker.io -y

apt-get install docker-compose -y

apt update -y

apt install fontconfig openjdk-17-jre -y

wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update -y

apt-get install jenkins -y

usermod -aG docker jenkins
usermod -aG docker ubuntu

# docker run -itd --name sonarqube -p 9000:9000 sonarqube:lts-community

# add port 9000,8080 in aws security group inbound rules
