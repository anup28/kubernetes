1. Use terraform to create the infrastructure consisting with one master and one worker node. While creating instances kubead kubelet kubectl will be pre installed.
1.1.  After that login to master node and grep the output of kubeadm init command for example (kubeadm join.............) and run it into worker node. After that we can see ready node on master (kubectl get nodes)

2. Now we have to install jenkins inside our k8s cluster. 
  2.1. kubectl create namespace jenkins
  2.2. kubectl create -f jenkins-deployment.yaml --namespace jenkins
  2.3. kubectl create -f jenkins-service.yaml --namespace jenkins
  2.4. http://node_ip_address:44000

3. Once Jenkins is ready run its first pipeline job consisting with platform.sh script.
3.1. platform.sh script takes care of
        creating development namespace

        deploying guest-book application

        Helm installation

        Helm install other applications like monitoring package, although the application is deployed via kubectl

        Creating a monitoring namespace

        Setting up prometheous

        Grafana is installed

        Blue/Green and Canary deployment will be taken care using app-gateway.yaml, changing the weight and with help of istio

        Almost everything is automated.
