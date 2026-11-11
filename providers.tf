#Configure la connexion à AWS
provider "aws" {
  region  = "eu-north-1" #région AWS (Stockholm eu-north-1)
  profile = "terraform-lab"

}