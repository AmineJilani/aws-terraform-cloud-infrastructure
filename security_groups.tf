# Groupe de sécurité pour les ressources du sous-réseau public
resource "aws_security_group" "public" {
  name        = "public-terraform-lab" #nom du SG dans AWS
  description = "Security group for public subnet resources"
  vpc_id      = aws_vpc.main.id # VPC auquel il appartient

  # Règle entrante de SSH
  ingress {
    description = "Allow SSH access"
    from_port   = 22                    # Premier port autorisé
    to_port     = 22                    # Dernier port autorisé
    protocol    = "tcp"                 # type de protocole
    cidr_blocks = ["80.215.198.167/32"] # adresse IP publique et une seule grace au /32
  }
  # Règle entrante de HTTP (non chiffré)
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Toutes les adresses IPv4 peuvent accéder au port 80
  }
  # Règle sortante HTTPS
  # Cette règle autorise HTTPS vers toutes les destinations IPv4, mais uniquement sur le port 443.
  egress {
    description = "Allow HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Toutes les adresses IPv4 de destination 
  }
  # Règle sortante HTTP port 80
  #Cett règle permet  les mises à jour Ubunt et installer Nginx (serveur)
  egress {
    description = "Allow HTTP outbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sg-public"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

