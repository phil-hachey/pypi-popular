output "cluster_name" {
  value = "pypi-popular.k8s.local"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-pypi-popular-k8s-local.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-pypi-popular-k8s-local.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-pypi-popular-k8s-local.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-pypi-popular-k8s-local.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.us-east-1a-pypi-popular-k8s-local.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-pypi-popular-k8s-local.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-pypi-popular-k8s-local.name}"
}

output "region" {
  value = "us-east-1"
}

output "vpc_id" {
  value = "${aws_vpc.pypi-popular-k8s-local.id}"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_autoscaling_attachment" "master-us-east-1a-masters-pypi-popular-k8s-local" {
  elb                    = "${aws_elb.api-pypi-popular-k8s-local.id}"
  autoscaling_group_name = "${aws_autoscaling_group.master-us-east-1a-masters-pypi-popular-k8s-local.id}"
}

resource "aws_autoscaling_group" "master-us-east-1a-masters-pypi-popular-k8s-local" {
  name                 = "master-us-east-1a.masters.pypi-popular.k8s.local"
  launch_configuration = "${aws_launch_configuration.master-us-east-1a-masters-pypi-popular-k8s-local.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-east-1a-pypi-popular-k8s-local.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "pypi-popular.k8s.local"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-east-1a.masters.pypi-popular.k8s.local"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-us-east-1a"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "nodes-pypi-popular-k8s-local" {
  name                 = "nodes.pypi-popular.k8s.local"
  launch_configuration = "${aws_launch_configuration.nodes-pypi-popular-k8s-local.id}"
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = ["${aws_subnet.us-east-1a-pypi-popular-k8s-local.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "pypi-popular.k8s.local"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.pypi-popular.k8s.local"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "a-etcd-events-pypi-popular-k8s-local" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "pypi-popular.k8s.local"
    Name                 = "a.etcd-events.pypi-popular.k8s.local"
    "k8s.io/etcd/events" = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "a-etcd-main-pypi-popular-k8s-local" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "pypi-popular.k8s.local"
    Name                 = "a.etcd-main.pypi-popular.k8s.local"
    "k8s.io/etcd/main"   = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_elb" "api-pypi-popular-k8s-local" {
  name = "api-pypi-popular-k8s-loca-a40mnj"

  listener = {
    instance_port     = 443
    instance_protocol = "TCP"
    lb_port           = 443
    lb_protocol       = "TCP"
  }

  security_groups = ["${aws_security_group.api-elb-pypi-popular-k8s-local.id}"]
  subnets         = ["${aws_subnet.us-east-1a-pypi-popular-k8s-local.id}"]

  health_check = {
    target              = "SSL:443"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 5
  }

  idle_timeout = 300

  tags = {
    KubernetesCluster = "pypi-popular.k8s.local"
    Name              = "api.pypi-popular.k8s.local"
  }
}

resource "aws_iam_instance_profile" "masters-pypi-popular-k8s-local" {
  name = "masters.pypi-popular.k8s.local"
  role = "${aws_iam_role.masters-pypi-popular-k8s-local.name}"
}

resource "aws_iam_instance_profile" "nodes-pypi-popular-k8s-local" {
  name = "nodes.pypi-popular.k8s.local"
  role = "${aws_iam_role.nodes-pypi-popular-k8s-local.name}"
}

resource "aws_iam_role" "masters-pypi-popular-k8s-local" {
  name               = "masters.pypi-popular.k8s.local"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.pypi-popular.k8s.local_policy")}"
}

resource "aws_iam_role" "nodes-pypi-popular-k8s-local" {
  name               = "nodes.pypi-popular.k8s.local"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.pypi-popular.k8s.local_policy")}"
}

resource "aws_iam_role_policy" "additional-masters-pypi-popular-k8s-local" {
  name   = "additional.masters.pypi-popular.k8s.local"
  role   = "${aws_iam_role.masters-pypi-popular-k8s-local.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_additional.masters.pypi-popular.k8s.local_policy")}"
}

resource "aws_iam_role_policy" "additional-nodes-pypi-popular-k8s-local" {
  name   = "additional.nodes.pypi-popular.k8s.local"
  role   = "${aws_iam_role.nodes-pypi-popular-k8s-local.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_additional.nodes.pypi-popular.k8s.local_policy")}"
}

resource "aws_iam_role_policy" "masters-pypi-popular-k8s-local" {
  name   = "masters.pypi-popular.k8s.local"
  role   = "${aws_iam_role.masters-pypi-popular-k8s-local.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.pypi-popular.k8s.local_policy")}"
}

resource "aws_iam_role_policy" "nodes-pypi-popular-k8s-local" {
  name   = "nodes.pypi-popular.k8s.local"
  role   = "${aws_iam_role.nodes-pypi-popular-k8s-local.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.pypi-popular.k8s.local_policy")}"
}

resource "aws_internet_gateway" "pypi-popular-k8s-local" {
  vpc_id = "${aws_vpc.pypi-popular-k8s-local.id}"

  tags = {
    KubernetesCluster = "pypi-popular.k8s.local"
    Name              = "pypi-popular.k8s.local"
  }
}

resource "aws_key_pair" "kubernetes-pypi-popular-k8s-local-f13bff43a050ff6442a050dee1addfc3" {
  key_name   = "kubernetes.pypi-popular.k8s.local-f1:3b:ff:43:a0:50:ff:64:42:a0:50:de:e1:ad:df:c3"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.pypi-popular.k8s.local-f13bff43a050ff6442a050dee1addfc3_public_key")}"
}

resource "aws_launch_configuration" "master-us-east-1a-masters-pypi-popular-k8s-local" {
  name_prefix                 = "master-us-east-1a.masters.pypi-popular.k8s.local-"
  image_id                    = "ami-d88812a2"
  instance_type               = "t2.small"
  key_name                    = "${aws_key_pair.kubernetes-pypi-popular-k8s-local-f13bff43a050ff6442a050dee1addfc3.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-pypi-popular-k8s-local.id}"
  security_groups             = ["${aws_security_group.masters-pypi-popular-k8s-local.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-east-1a.masters.pypi-popular.k8s.local_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  spot_price = "0.011"
}

resource "aws_launch_configuration" "nodes-pypi-popular-k8s-local" {
  name_prefix                 = "nodes.pypi-popular.k8s.local-"
  image_id                    = "ami-d88812a2"
  instance_type               = "t2.small"
  key_name                    = "${aws_key_pair.kubernetes-pypi-popular-k8s-local-f13bff43a050ff6442a050dee1addfc3.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-pypi-popular-k8s-local.id}"
  security_groups             = ["${aws_security_group.nodes-pypi-popular-k8s-local.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.pypi-popular.k8s.local_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  spot_price = "0.1"
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.pypi-popular-k8s-local.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.pypi-popular-k8s-local.id}"
}

resource "aws_route_table" "pypi-popular-k8s-local" {
  vpc_id = "${aws_vpc.pypi-popular-k8s-local.id}"

  tags = {
    KubernetesCluster = "pypi-popular.k8s.local"
    Name              = "pypi-popular.k8s.local"
  }
}

resource "aws_route_table_association" "us-east-1a-pypi-popular-k8s-local" {
  subnet_id      = "${aws_subnet.us-east-1a-pypi-popular-k8s-local.id}"
  route_table_id = "${aws_route_table.pypi-popular-k8s-local.id}"
}

resource "aws_route_table_association" "us-east-1b-pypi-popular-k8s-local" {
  subnet_id      = "${aws_subnet.us-east-1b-pypi-popular-k8s-local.id}"
  route_table_id = "${aws_route_table.pypi-popular-k8s-local.id}"
}

resource "aws_security_group" "api-elb-pypi-popular-k8s-local" {
  name        = "api-elb.pypi-popular.k8s.local"
  vpc_id      = "${aws_vpc.pypi-popular-k8s-local.id}"
  description = "Security group for api ELB"

  tags = {
    KubernetesCluster = "pypi-popular.k8s.local"
    Name              = "api-elb.pypi-popular.k8s.local"
  }
}

resource "aws_security_group" "masters-pypi-popular-k8s-local" {
  name        = "masters.pypi-popular.k8s.local"
  vpc_id      = "${aws_vpc.pypi-popular-k8s-local.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "pypi-popular.k8s.local"
    Name              = "masters.pypi-popular.k8s.local"
  }
}

resource "aws_security_group" "nodes-pypi-popular-k8s-local" {
  name        = "nodes.pypi-popular.k8s.local"
  vpc_id      = "${aws_vpc.pypi-popular-k8s-local.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "pypi-popular.k8s.local"
    Name              = "nodes.pypi-popular.k8s.local"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-pypi-popular-k8s-local.id}"
  source_security_group_id = "${aws_security_group.masters-pypi-popular-k8s-local.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-pypi-popular-k8s-local.id}"
  source_security_group_id = "${aws_security_group.masters-pypi-popular-k8s-local.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-pypi-popular-k8s-local.id}"
  source_security_group_id = "${aws_security_group.nodes-pypi-popular-k8s-local.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "api-elb-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.api-elb-pypi-popular-k8s-local.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-api-elb-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.api-elb-pypi-popular-k8s-local.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-elb-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-pypi-popular-k8s-local.id}"
  source_security_group_id = "${aws_security_group.api-elb-pypi-popular-k8s-local.id}"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-pypi-popular-k8s-local.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-pypi-popular-k8s-local.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-pypi-popular-k8s-local.id}"
  source_security_group_id = "${aws_security_group.nodes-pypi-popular-k8s-local.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-pypi-popular-k8s-local.id}"
  source_security_group_id = "${aws_security_group.nodes-pypi-popular-k8s-local.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-pypi-popular-k8s-local.id}"
  source_security_group_id = "${aws_security_group.nodes-pypi-popular-k8s-local.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-pypi-popular-k8s-local.id}"
  source_security_group_id = "${aws_security_group.nodes-pypi-popular-k8s-local.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-pypi-popular-k8s-local.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-pypi-popular-k8s-local.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "us-east-1a-pypi-popular-k8s-local" {
  vpc_id            = "${aws_vpc.pypi-popular-k8s-local.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "us-east-1a"

  tags = {
    KubernetesCluster                              = "pypi-popular.k8s.local"
    Name                                           = "us-east-1a.pypi-popular.k8s.local"
    "kubernetes.io/cluster/pypi-popular.k8s.local" = "shared"
    "kubernetes.io/role/alb-ingress" = ""
  }
}

resource "aws_subnet" "us-east-1b-pypi-popular-k8s-local" {
  vpc_id            = "${aws_vpc.pypi-popular-k8s-local.id}"
  cidr_block        = "172.20.0.0/19"
  availability_zone = "us-east-1b"

  tags = {
    KubernetesCluster                              = "pypi-popular.k8s.local"
    Name                                           = "us-east-1b.pypi-popular.k8s.local"
    "kubernetes.io/cluster/pypi-popular.k8s.local" = "shared"
    "kubernetes.io/role/alb-ingress" = ""
  }
}

resource "aws_vpc" "pypi-popular-k8s-local" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                              = "pypi-popular.k8s.local"
    Name                                           = "pypi-popular.k8s.local"
    "kubernetes.io/cluster/pypi-popular.k8s.local" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "pypi-popular-k8s-local" {
  domain_name         = "ec2.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster = "pypi-popular.k8s.local"
    Name              = "pypi-popular.k8s.local"
  }
}

resource "aws_vpc_dhcp_options_association" "pypi-popular-k8s-local" {
  vpc_id          = "${aws_vpc.pypi-popular-k8s-local.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.pypi-popular-k8s-local.id}"
}

terraform = {
  required_version = ">= 0.9.3"
}
