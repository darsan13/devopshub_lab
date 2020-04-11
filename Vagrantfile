# -*- mode: ruby -*-
# vi: set ft=ruby :

$setup = <<SCRIPT

# Install epel

yum install epel-release

# Install network tools

yum install -y net-tools

# Enable root login in ssh configuration

sed -i "s/^PermitRootLogin no/PermitRootLogin yes/g" /etc/ssh/sshd_config
sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
service sshd restart

# Install git

yum install -y git

# Install ansible

yum install ansible

# Install Jenkins

yum install java-1.8.0-openjdk-devel

curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo

rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key

yum install jenkins

systemctl status jenkins

systemctl enable jenkins

SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.hostname = "devops-server"
  # config.vm.network "private_network", ip: "192.168.2.10"
  config.vm.network "public_network"
  config.vm.provision "shell", inline:$setup 
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
  
  config.vm.define "devops_server" do |devops_erver|
  end
end
