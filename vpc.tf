# VPC - Virtual Private Cloud
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" #définit la plage IP du VPC

  enable_dns_support   = true #active la résolution DNS
  enable_dns_hostnames = true #Autorise les noms DNS public pour les ressources compatible

  #Des étiquettes pour identifier les ressources
  tags = {
    Name        = "vpc-terraform-lab"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}