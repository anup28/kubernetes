1. Use terraform to create the infrastructure consisting with one master and one worker node. While creating instances kubead kubelet kubectl will be pre installed.
1.1.  After that login to master node and grep the output of kubeadm init command for example (kubeadm join.............) and run it into worker node. After that we can see ready node on master (kubectl get nodes)
