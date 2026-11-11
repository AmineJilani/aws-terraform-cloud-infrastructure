# Enregistrer la clé publique dans AWS
resource "aws_key_pair" "main" {
  key_name   = "aws-terraform-lab"                              #nom sous lequel AWS identifiera la clé.
  public_key = file("/home/ajilani/.ssh/aws-terraform-lab.pub") # fichier de clé publique

  tags = {
    Name        = "key-terraform-lab"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}