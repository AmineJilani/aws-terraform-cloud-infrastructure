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