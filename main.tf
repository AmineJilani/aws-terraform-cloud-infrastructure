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

#Subnet Public
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id # id du VPC auquel appartient le subnet
  cidr_block        = "10.0.1.0/24"   # plage d'adresses IP du subnet
  availability_zone = "eu-north-1a"   # zone de disponibilité AWS

  map_public_ip_on_launch = true #Attribue une IPv4 publique aux nouvelles instances lancées dans ce subnet
  tags = {
    Name        = "subnet_public"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}
#Subnet private
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1a"

  map_public_ip_on_launch = false # désavtive l'attribution auto d'IP publique
  tags = {
    Name        = "subnet_private"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

#Internet GateWay
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # rattacher la passerelle au VPC

  tags = {
    Name        = "igw-terraform-lab"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

#Table de routage publique
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "rt-public"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

#Ajouter la route Internet 
resource "aws_route" "public_internet" {
  # Indique dans quelle table ajouter la route
  route_table_id = aws_route_table.public.id
  # Destinations IPv4
  destination_cidr_block = "0.0.0.0/0"
  # Indique que le trafic doit passer par IGW
  gateway_id = aws_internet_gateway.main.id
}

#Associer la route table au subnet public 
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id      # le sous réseau public 
  route_table_id = aws_route_table.public.id # la table de routage contenant la route Internet
}

#Groupe de sécurité public 
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



# Table de routage privée
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "rt-private"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

# Associer la route table privée au subnet privée
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

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

# Déclarer l'instance EC2
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id         # Image Ubuntu récupérée 
  instance_type               = "t3.micro"                     #Puissance de la machine
  subnet_id                   = aws_subnet.public.id           # Installation dans subnet public
  vpc_security_group_ids      = [aws_security_group.public.id] # Application de SG
  key_name                    = aws_key_pair.main.key_name     #Association de clé SSH
  associate_public_ip_address = true                           #Attribuer une IP publique

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

output "aws_account_id" {
  description = "Identifiant du compte AWS"
  value       = data.aws_caller_identity.current.account_id
}
output "aws_region" {
  description = "Région AWS utilisée"
  value       = data.aws_region.current.region
}
output "vpc_id" {
  description = "Identifiant du VPC créé"
  value       = aws_vpc.main.id
}
output "subnet_public_id" {
  description = "Identifiant de sous réseau public créé"
  value       = aws_subnet.public.id
}
output "subnet_private_id" {
  description = "Identifiant de sous réseau privé créé"
  value       = aws_subnet.private.id
}
output "route_table_public_id" {
  description = "Identifiant de la table de routage publique"
  value       = aws_route_table.public.id
}
output "route_table_private_id" {
  description = "Identifiant de la table de routage privée"
  value       = aws_route_table.private.id
}
output "ec2_instance_id" {
  description = "Identifiant de l'instance EC2"
  value       = aws_instance.web.id
}
output "ec2_public_ip" {
  description = "Adresse IPv4 publique"
  value       = aws_instance.web.public_ip
}
output "ec2_private_ip" {
  description = "Adresse IPv4 privée"
  value       = aws_instance.web.private_ip
}
output "ec2_public_dns" {
  description = "Nom DNS public"
  value       = aws_instance.web.public_dns
}