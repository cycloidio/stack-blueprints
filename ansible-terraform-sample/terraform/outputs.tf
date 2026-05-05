# Example on how to use Terraform outputs https://developer.hashicorp.com/terraform/language/values/outputs
# Terraform outputs are automatically passed as variables to the Ansible playbook
# by the Cycloid ansible-runner (when tfstate is given as input to the merge task).
output "tshirt_id" {
  value = try(module.example.tshirt_id, "")
}
