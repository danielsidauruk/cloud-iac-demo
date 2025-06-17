resource "aws_security_group" "cluster" {
  name        = "${var.application_name}-${var.environment_name}-cluster"
  description = "Allow access to Cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port = 0
    to_port   = 0

    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "cluster_ingress_https" {

  security_group_id = aws_security_group.cluster.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
  description       = "Cluster Ingress HTTPs"
  protocol          = "tcp"

}

resource "aws_security_group_rule" "nodeport_cluster_tcp" {

  security_group_id = aws_security_group.cluster.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 30000
  to_port           = 32768
  description       = "Nodeport Cluster Ingress tcp"
  protocol          = "tcp"

}

resource "aws_security_group_rule" "nodeport_cluster_udp" {

  security_group_id = aws_security_group.cluster.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 30000
  to_port           = 32768
  description       = "Nodeport Cluster udp"
  protocol          = "udp"

}

resource "aws_security_group" "cluster_nodes" {
  name        = "${var.application_name}-${var.environment_name}-cluster-nodes"
  description = "Allow access to Cluster Nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port = 0
    to_port   = 0

    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "nodeport_tcp" {

  security_group_id = aws_security_group.cluster_nodes.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 30000
  to_port           = 32768
  description       = "Nodeport tcp"
  protocol          = "tcp"

}
