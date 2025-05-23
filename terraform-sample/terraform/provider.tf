variable "organization" {}
variable "project" {}
variable "env" {}
variable "component" {}

($> if eq .stack_usecase "aws" -<$)
# Terraform Amazon Web Services provider configuration
# See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  access_key = var.aws_cred.access_key
  secret_key = var.aws_cred.secret_key
  region     = var.aws_region

  default_tags { # The default_tags block applies tags to all resources managed by this provider, except for the Auto Scaling groups (ASG).
    tags = {
      "cycloid.io" = "true"
      component    = var.component
      env          = var.env
      project      = var.project
      organization = var.organization
    }
  }
}

variable "aws_cred" {} # { access_key, secret_key }

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}

($> else if eq .stack_usecase  "gcp" -<$)
# Terraform Google provider configuration
# See: https://registry.terraform.io/providers/hashicorp/google/latest/docs
terraform {
  required_providers {
    google = {
      source  = "google"
    }
  }
}

provider "google" {
  project = var.gcp_project
}

variable "gcp_project" {
  default = "cycloid-demo"
}

variable "gcp_zone" {
  default = "europe-west1-b"
}

($> else if  eq .stack_usecase "azure" -<$)
# Terraform Azure provider configuration
# See: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
    }
  }
}

provider "azurerm" {
  environment     = var.azure_env
  client_id       = var.azure_cred.client_id
  client_secret   = var.azure_cred.client_secret
  subscription_id = var.azure_cred.subscription_id
  tenant_id       = var.azure_cred.tenant_id
  features {}
}

variable "azure_cred" {} # { subscription_id, tenant_id, client_id, client_secret }

variable "azure_env" {
  default = "public"
}

($>- end -<$)
