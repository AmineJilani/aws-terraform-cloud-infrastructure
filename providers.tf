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
#Configure la connexion à AWS
provider "aws" {
  region = "eu-north-1" #région AWS (Stockholm eu-north-1)
}