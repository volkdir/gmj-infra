#!/bin/sh
sleep 30
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2 \
  snapd \
  golang \
  azure-cli \
  powershell \
  zip \
  curl \
  java-11-openjdk \
  java-1.8.0-openjdk-devel

#setup docker
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce java-1.8.0-openjdk
sudo usermod -aG docker centos
echo modify docker.service
sudo mkdir /etc/systemd/system/docker.service.d


echo reload docker.service
sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl start docker.service
docker swarm init

# configure snap
sudo ln -s /var/lib/snapd/snap /snap
sudo systemctl enable --now snapd.socket

# install classic snaps
sudo snap install --classic microk8s 

# microk8s setup
sudo usermod -a -G microk8s centos
sudo chown -f -R centos /home/centos/.kube


echo ## download and install kube ctl and  #################################################

sudo curl -o /usr/bin/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
sudo chmod +x /usr/bin/kubectl
sudo curl -o helm.tgz https://get.helm.sh/helm-v2.16.5-linux-amd64.tar.gz ;\
    tar -zxvf helm.tgz; \
    cp linux-amd64/helm /usr/bin; \
    cp linux-amd64/tiller /usr/bin;

