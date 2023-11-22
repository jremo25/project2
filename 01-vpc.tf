resource "aws_vpc" "app1" {
  cidr_block           = "10.32.0.0/16"
  enable_dns_support   = true 
  enable_dns_hostnames = true 

  tags = {
    Name    = "app1"
    Service = "application1"
    Owner   = "Revan"
    Planet  = "OuterRim"
  }
}
