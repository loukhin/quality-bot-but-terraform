data "aws_availability_zones" "available" {}

resource "aws_vpc" "Quality_VPC" {
    
    cidr_block = var.network_address_space
    enable_dns_hostnames = true

    tags ={
        Name = "${var.pName}-VPC"
        
    }
}

resource "aws_internet_gateway" "QualityIgw" {
  vpc_id = aws_vpc.Quality_VPC.id

  tags ={ Name = "${var.pName}-IGW"}
}

resource "aws_subnet" "PublicNets" {
  count = var.subnet_count
  cidr_block              = cidrsubnet(var.network_address_space, 8, count.index)
  vpc_id                  = aws_vpc.Quality_VPC.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags =  { Name = "${var.pName}-publicsubnet${count.index}"}
}

# ROUTING #
resource "aws_route_table" "publicRoute" {
  vpc_id = aws_vpc.Quality_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.QualityIgw.id
  }

  tags = { Name = "${var.pName}-PublicRouteTable"}
}

resource "aws_route_table_association" "rt-pubsub" {
  count = var.subnet_count
  subnet_id      = aws_subnet.PublicNets[count.index].id
  route_table_id = aws_route_table.publicRoute.id
}




