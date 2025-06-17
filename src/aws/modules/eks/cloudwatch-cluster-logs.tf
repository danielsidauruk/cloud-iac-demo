resource "aws_cloudwatch_log_group" "container_cluster" {
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 7

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-cloudwatch"
    application = var.application_name
    environment = var.environment_name
  }
}