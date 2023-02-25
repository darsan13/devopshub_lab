# Grow K8S cluster and CMDs



## Description

K8s command for join a worker node.

Some command to manage the cluster.

Tested and approuved on Ubuntu 20.04 LTS.



## Command

### Follow the same steps until installed k8s

Add cp id add

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

On cp (tokens works for 2 hrs):

```bash
sudo kubeadm token list      # check all the tokens
sudo kubeadm token create
openssl x509 -pubkey \
-in /etc/kubernetes/pki/ca.crt | openssl rsa \
-pubin -outform der 2>/dev/null | openssl dgst \
-sha256 -hex | sed 's/ˆ.* //'
```

On worker node:

```bash
kubeadm join k8scp:6443 --token nr823f.90q4gnh2qgcy3lg9 --discovery-token-ca-cert-hash sha256:50d3f0bf1e69060deeab80dd672241f6fb3b6e308e02b54457544fc422f5e9e3
```

**Check it works on cp.**

```bash
kubectl get nodes
NAME           STATUS   ROLES           AGE     VERSION
ubuntu-node1   Ready    control-plane   10h     v1.24.1
ubuntu-node2   Ready    <none>          4m28s   v1.24.1
```

**Containerd may still be using an out of date notation for the runtime-endpoint**. You may see errors about an undeclared

resource type such as *unix*//:. We will update the crictl configuration. There are many possible configuration

options. We will set one, and view the configuration file that is created.

```bash
sudo crictl config --set \
runtime-endpoint=unix:///run/containerd/containerd.sock \
--set image-endpoint=unix:///run/containerd/containerd.sock
sudo cat /etc/crictl.yaml
```



**CMDs for management**

```bash
kubectl get nodes/pods/service
kubectl get pods --all-namespaces

kubectl create
kubectl create deployment nginx-depl --image=nginx
kubectl get deployment

kubectl get pods
kubectl get replicaset

kubectl edit deployment nginx-depl
kubectl get pods
kubectl get replicaset

# FOR Debug:
kubuctl logs [pod-name]
kubectl describe pod [pod-name]
kubectl exec -it mongo-depl-8fbdb868c-z9xnf -- bin/bash
kubectl edit deployment nginx-depl -o yaml > filename.yaml

kubectl delete deployment mongo-depl

kubectl apply -f [file name]
