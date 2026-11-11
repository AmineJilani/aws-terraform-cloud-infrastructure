# Déclarer l'instance EC2
resource "aws_instance" "web" {
  ami                    = "ami-06fb1802e2b757f09"        # Image Ubuntu récupérée 
  instance_type          = "t3.micro"                     #Puissance de la machine
  subnet_id              = aws_subnet.public.id           # Installation dans subnet public
  vpc_security_group_ids = [aws_security_group.public.id] # Application de SG
  key_name               = aws_key_pair.main.key_name     #Association de clé SSH
  #associate_public_ip_address = true                           #Attribuer une IP publique

  #Configuration du disque système
  #RQ : Le disque sera chiffré et supprimé automatiquement lorsque l'instance sera terminée.
  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = "ec2-ubuntu-terraform-lab"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}
