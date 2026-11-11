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