variable "application_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "cluster_name" {
  type        = string
  description = "Provided by the GitHub Action"
  default     = "eks-openmusicapi-dev" /* Will be deleted */
}
variable "primary_region" {
  type        = string
  description = "Provided by the GitHub Action"
  default     = "ap-southeast-1" /* Will be deleted */
}
variable "k8s_namespace" {
  type = string
}
variable "k8s_service_account_name" {
  type = string
}
variable "web_app_image" {
  type = object({
    name    = string
    version = string
  })
}
variable "web_api_image" {
  type = object({
    name    = string
    version = string
  })
}
variable "alb_controller_role" {
  type    = string
  default = "arn:aws:iam::010928221623:role/aws-load-balancer-controller-role" /* Will be deleted */
}
variable "workload_identity_role" {
  type    = string
  default = "arn:aws:iam::010928221623:role/openmusicapi-dev-workload-identity" /* Will be deleted */
}

#  TF_VAR_application_name: ${{ vars.APPLICATION_NAME }}
#  TF_VAR_environment_name: ${{ vars.ENVIRONMENT_NAME }}
#  TF_VAR_cluster_name: ${{ needs.infra.outputs.kubernetes_cluster_name }}
#  TF_VAR_primary_region: ${{ needs.infra.outputs.primary_region }}
#  TF_VAR_alb_controller_role: ${{ needs.infra.outputs.alb_controller_role }}
#  TF_VAR_workload_identity_role: ${{ needs.infra.outputs.workload_identity_role }}

/* aws eks update-kubeconfig --region "ap-southeast-1" --name "eks-openmusicapi-dev" */

/*
    eksctl get iamidentitymapping \
        --cluster "eks-openmusicapi-dev" \
        --region="ap-southeast-1"
*/

/*
    eksctl create iamidentitymapping \
      --cluster "eks-openmusicapi-dev" \
      --region="ap-southeast-1" \
      --arn arn:aws:iam::010928221623:role/openmusicapi-dev-console-access \
      --group eks-console-dashboard-full-access-group \
      --no-duplicate-arns
*/

/*
    eksctl create iamidentitymapping \
      --cluster "eks-openmusicapi-dev" \
      --region="ap-southeast-1" \
      --arn arn:aws:iam::010928221623:user/developer \
      --group eks-console-dashboard-restricted-access-group \
      --no-duplicate-arns
*/

# admin_group_arn = "arn:aws:iam::010928221623:group/openmusicapi-dev-admin"
# alb_controller_role = "arn:aws:iam::010928221623:role/aws-load-balancer-controller-role"
# backend_repository = "ecr-openmusicapi-dev-main"
# backend_repository_url = "010928221623.dkr.ecr.ap-southeast-1.amazonaws.com/ecr-openmusicapi-dev-consumer"
# frontend_repository = "ecr-openmusicapi-dev-main"
# frontend_repository_url = "010928221623.dkr.ecr.ap-southeast-1.amazonaws.com/ecr-openmusicapi-dev-consumer"
# kubernetes_cluster_name = "eks-openmusicapi-dev"
# primary_region = "ap-southeast-1"
# workload_identity_role = "arn:aws:iam::010928221623:role/openmusicapi-dev-workload-identity"