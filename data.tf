# Informations existante sur AWS sans créer une ressource
data "aws_ami" "ubuntu" {
  most_recent = true #AMI plus récente
  owners      = ["099720109477"]

  # Filtre sur l'image ou le modèle selon le nom et virtualisation
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Informations sur le compte AWS
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}