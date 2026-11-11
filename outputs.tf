# Informations générales
output "aws_account_id" {
  description = "Identifiant du compte AWS"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "Région AWS utilisée"
  value       = data.aws_region.current.region
}

# Réseau
output "vpc_id" {
  description = "Identifiant du VPC créé"
  value       = aws_vpc.main.id
}

output "subnet_public_id" {
  description = "Identifiant du sous-réseau public"
  value       = aws_subnet.public.id
}

output "subnet_private_id" {
  description = "Identifiant du sous-réseau privé"
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

# Instance EC2
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