provider "aws" {
  region     = "${var.aws_region}"
  profile    = "${var.aws_profile}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"

  assume_role {
    role_arn = "${var.aws_assume_role}"
  }
}

data "aws_availability_zones" "available" {}



resource "aws_instance" "master" {
  # Amazon optimized EKS AMI
  ami           = "ami-08e2b16807644cf1d"
  count         = 1
  vpc           = ${var.vpc_name}
  instance_type = "t2.medium"

  key_name = "${aws_key_pair.main.id}"

  associate_public_ip_address = "true"

  vpc_security_group_ids = ["${aws_security_group.cluster_security_group.id}", "${aws_security_group.all_worker_mgmt.id}", "${aws_security_group.allow_bootstrap_access.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "60"
    delete_on_termination = true
  }

  connection {
    host        = "${self.public_ip}"
    type        = "ssh"
    timeout     = "6m"
    user        = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-get update",
      "sudo apt-get install -y apt-transport-https",
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add",
      "cat <<EOF > /etc/apt/sources.list.d/kubernetes.list",
      "deb http://apt.kubernetes.io/ kubernetes-xenial main",
      "EOF",
      "apt-get install -y docker.io",
      "apt-get install -y kubelet kubeadm kubectl kubernetes-cni",
      "kubeadm init",
      "mkdir -p $HOME/.kube",
      "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
      "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
      "sysctl net.bridge.bridge-nf-call-iptables=1",
      "export kubever=$(kubectl version | base64 | tr -d '\n')",
      "kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"",

    ]
  }


resource "aws_instance" "worker0" {
  ami           = "ami-08e2b16807644cf1d"
  count         = 1
  vpc           = ${var.vpc_name}
  instance_type = "t2.micro"

  # iam_instance_profile = "${var.bastion_instance_profile_name}"
  key_name = "${aws_key_pair.main.id}"


  vpc_security_group_ids = ["${aws_security_group.cluster_security_group.id}", "${aws_security_group.all_worker_mgmt.id}", "${aws_security_group.allow_bootstrap_access.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "60"
    delete_on_termination = true
  }

  connection {
    host        = "${self.public_ip}"
    type        = "ssh"
    timeout     = "6m"
    user        = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-get update",
      "sudo apt-get install -y apt-transport-https",
      "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add",
      "cat <<EOF > /etc/apt/sources.list.d/kubernetes.list",
      "deb http://apt.kubernetes.io/ kubernetes-xenial main",
      "EOF",
      "apt-get install -y docker.io",
      "apt-get install -y kubelet kubeadm kubectl kubernetes-cni",
    ]
  }

  lifecycle {
    ignore_changes = ["*"]
  }


