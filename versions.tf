terraform {
  #indique les providers nécessaires
  required_providers {
    aws = {
      source  = "hashicorp/aws" # précise qu'on utilise le provider officiel HashiCorp AWS
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0" #impose Terraform 1.5 ou plus
}