#!/bin/bash
sudo yum update –y
#sudo amazon-linux-extras install java-openjdk11 -y
sudo dnf install java-openjdk11 -y
sudo dnf install -y java-17-amazon-corretto
java -version
readlink -f $(which java)
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
cd /opt/
sudo wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.48/bin/apache-tomcat-10.1.48.tar.gz 
ls
sudo tar -xzvf apache-tomcat-10.1.48.tar.gz
ls
sudo mv apache-tomcat-10.1.48 tomcat10
sudo chown ec2-user:ec2-user tomcat10/ -R
cd tomcat10/bin/
./startup.sh
