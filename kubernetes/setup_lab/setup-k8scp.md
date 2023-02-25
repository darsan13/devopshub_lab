# Setup K8S control plane



## Description

K8s command for installation.

Tested and approuved on Ubuntu 20.04 LTS.

Motified from https://gitlab.com/steve.decot/k8s-install/-/blob/main/README.md.



## Command

### Context

```bash
lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 20.04.5 LTS
Release:        20.04
Codename:       focal
```

```bash
hostname
k8scp
```

### Preparation

```bash
apt-get update && apt-get upgrade -y
```

```bash
apt install curl apt-transport-https vim git wget gnupg2 \
software-properties-common apt-transport-https ca-certificates uidmap -y
```

Disable swap otherwise the cluster don't init.

```bash
swapoff -a
```

by default, the firewall is disabled.

```bash
systemctl stop ufw
ufw disable
Firewall stopped and disabled on system startup
```

Load this two modules

```bash
modprobe overlay
```

```bash
modprobe br_netfilter
```

Add this config

```bash
cat << EOF | tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
```

Check and apply

```bash
sysctl --system
```

Add key

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
```

Return if good

```bash
OK
```


```bash
apt install containerd -y
```

Also containerd.io is needed:

https://github.com/containerd/containerd/blob/main/docs/getting-started.md

```bash
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install containerd.io
```

```bash
rm /etc/containerd/config.toml
systemctl restart containerd
```



### K8s

```bash
vim /etc/apt/sources.list.d/kubernetes.list
```

add this

```bash
deb http://apt.kubernetes.io/ kubernetes-xenial main
```

```bash
curl -s \
https://packages.cloud.google.com/apt/doc/apt-key.gpg \
| apt-key add -
```

return expected

```bash
OK
```

```bash
apt-get update
```

```bash
apt-get install -y kubeadm=1.24.1-00 kubelet=1.24.1-00 kubectl=1.24.1-00
```

```bash
apt-mark hold kubelet kubeadm kubectl
```

```bash
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml -O
```

```bash
less calico.yaml
```

Check those lines and remmember

```bash
   - name: FELIX_WIREGUARDMTU
              valueFrom:
                configMapKeyRef:
                  name: calico-config
                  key: veth_mtu
            # The default IPv4 pool to create on startup if none exists. Pod IPs will be
            # chosen from this range. Changing this value after installation will have
            # no effect. This should fall within `--cluster-cidr`.
            # - name: CALICO_IPV4POOL_CIDR
            #   value: "192.168.0.0/16"
            # Disable file logging so `kubectl logs` works.
```

Check your id address

```bash
ip a
```

```bash
 vim /etc/hosts
```

```bash
127.0.0.1       localhost
192.168.1.5 k8scp
# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

Create and add this config yaml for your cluster

```bash
vim kubeadm-config.yaml
```

**CHECK Your HOSTNAME and your CIDR . **

```bash
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: 1.24.1 #<-- Use the word stable for newest version
controlPlaneEndpoint: "k8scp:6443" #<-- Use the alias we put in /etc/hosts not the IP
networking:
  podSubnet: 192.168.1.0/16 #<-- Match the IP range from the Calico config file
```

Init your cluster

```bash
kubeadm init --config=kubeadm-config.yaml --upload-certs \
| tee kubeadm-init.out
```

For use with root user

```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
```

For regular user

```bash
exit
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

**Apply the network plugin configuration to your cluster.**

```bash
sudo cp /root/calico.yaml .
kubectl apply -f calico.yaml
```

**Check it works.**

```bash
kubectl get nodes
NAME           STATUS   ROLES           AGE   VERSION
ubuntu-node1   Ready    control-plane   29m   v1.24.1
```

**Auto-completion for kubectl**.

```bash
sudo apt-get install bash-completion -y                       # install bash-completion
<exit and log back in>
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> $HOME/.bashrc     # /home/<username> for ubuntu
```



## Possible issues

- Container running time error

```bash
rm /etc/containerd/config.toml
systemctl restart containerd
```

- The connection to the server: 6443 was refused (after restart)

```bash
sudo -i
swapoff -a
exit
strace -eopenat kubectl version
```

- Always check the logs

```bash
journalctl -xeu kubelet
```

- The connection to the server localhost:8080

For use with root user

```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
```

For regular user

```bash
exit
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
