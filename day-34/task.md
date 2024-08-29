## Kubernetes Cluster Setup with Calico Networking

This README provides instructions for setting up a Kubernetes cluster with Calico networking. It covers the installation of required packages, initialization of the cluster, and joining worker nodes.

## Prerequisites

- Control Plane Node and Worker Nodes should be running Ubuntu 20.04 or later.
- Ensure all nodes can communicate with each other over the network.
- SSH access to all nodes.

### 1. Log in to Control Plane Node

Log in to your control plane node via SSH or any preferred method.

![alt text](<images/Screenshot from 2024-08-28 16-17-45.png>)
---


### 2. Install Packages on All Nodes

### On All Nodes (Control Plane and Workers)

1. **Log in to the control plane node.**

2. **Create the Configuration File for containerd:**

```
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```

3. **Load the Modules:**

```
sudo modprobe overlay
sudo modprobe br_netfilter
```

4. **Set the System Configurations for Kubernetes Networking:**

```
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```

5. **Apply the New Settings:**

```
sudo sysctl --system
```
![alt text](<images/Screenshot from 2024-08-28 16-21-33.png>)
---


6. **Install containerd:**

```
sudo apt-get update && sudo apt-get install -y containerd.io
```

7. **Create the Default Configuration File for containerd:**

```
sudo mkdir -p /etc/containerd
```

8. **Generate the Default containerd Configuration and Save It:**

```
sudo containerd config default | sudo tee /etc/containerd/config.toml
```

![alt text](<images/Screenshot from 2024-08-28 16-49-52.png>)
---


9. **Restart containerd:**

```
sudo systemctl restart containerd
```

10. **Verify that containerd is Running:**

```
sudo systemctl status containerd
```

![alt text](<images/Screenshot from 2024-08-28 16-50-42.png>)
---


11. **Disable Swap:**

```
sudo swapoff -a
```

12. **Install Dependency Packages:**

```
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
```

![alt text](<images/Screenshot from 2024-08-28 16-51-40.png>)
---


13. **Download and Add the GPG Key:**

```
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.27/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

14. **Add Kubernetes to the Repository List:**

```
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /
EOF
```

15. **Update the Package Listings:**

```
sudo apt-get update
```
![alt text](<images/Screenshot from 2024-08-28 16-52-31.png>)
---


16. **Install Kubernetes Packages & Turn Off Automatic Updates:**

```
sudo apt-get install -y kubelet kubeadm kubectl
```
```
sudo apt-mark hold kubelet kubeadm kubectl
```
![alt text](<images/Screenshot from 2024-08-28 16-53-42.png>)
![alt text](<images/Screenshot from 2024-08-28 16-54-36.png>)
---


18. **Log in to Worker Nodes and Repeat the Above Steps.**

### 3. Initialize the Cluster

### On the Control Plane Node

1. **Initialize the Kubernetes Cluster:**

```
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.27.11
```
![alt text](<images/Screenshot from 2024-08-28 16-58-54.png>)
---


2. **Set kubectl Access:**

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
![alt text](<images/Screenshot from 2024-08-28 16-59-47.png>)
---


### 4. Install the Calico Network Add-On

### On the Control Plane Node

1. **Install Calico Networking:**

```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
```
![alt text](<images/Screenshot from 2024-08-28 17-00-37.png>)
---


2. **Check the Status of the Control Plane Node:**

```
kubectl get nodes
```
![alt text](<images/Screenshot from 2024-08-28 17-02-40.png>)
---


### 5. Join the Worker Nodes to the Cluster

### On the Control Plane Node

1. **Create the Token and Copy the Join Command:**

```
kubeadm token create --print-join-command
```
![alt text](<images/Screenshot from 2024-08-28 17-02-40.png>)
---


### On Each Worker Node

1. **Paste the Full Join Command:**

```
sudo kubeadm join <token>
```