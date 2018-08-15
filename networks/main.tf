

provider "aws" {
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
  region = "eu-west-1"
}

resource "aws_vpc" "rr-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "rr-vpc"
    }
}

resource "aws_internet_gateway" "rr-igw" {
  vpc_id = "${aws_vpc.rr-vpc.id}"
}

resource "aws_route_table" "rr-rtb-secure" {
    vpc_id = "${aws_vpc.rr-vpc.id}"
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.rr-igw.id}"
    }
}
resource "aws_route_table" "rr-rtb-dmz" {
    vpc_id = "${aws_vpc.rr-vpc.id}"
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.rr-igw.id}"
    }
}
resource "aws_subnet" "rr-subnet-dmz-1" {
    availability_zone = "eu-west-1a"
    vpc_id = "${aws_vpc.rr-vpc.id}"
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "rr-subnet-dmz-1"
    }
}
resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.rr-subnet-dmz-1.id}"
  route_table_id = "${aws_route_table.rr-rtb-dmz.id}"
}

resource "aws_subnet" "rr-subnet-dmz-2" {
    availability_zone = "eu-west-1b"
    vpc_id = "${aws_vpc.rr-vpc.id}"
    cidr_block = "10.0.2.0/24"
    tags = {
        Name = "rr-subnet-dmz-2"
    }
}

resource "aws_route_table_association" "b" {
  subnet_id      = "${aws_subnet.rr-subnet-dmz-2.id}"
  route_table_id = "${aws_route_table.rr-rtb-dmz.id}"
}

resource "aws_subnet" "rr-subnet-secure-1" {
    vpc_id = "${aws_vpc.rr-vpc.id}"
    availability_zone = "eu-west-1a"
    cidr_block = "10.0.3.0/24"
    tags = {
        Name = "rr-subnet-secure-1"
    }
}
resource "aws_route_table_association" "c" {
  subnet_id      = "${aws_subnet.rr-subnet-secure-1.id}"
  route_table_id = "${aws_route_table.rr-rtb-secure.id}"
}

resource "aws_subnet" "rr-subnet-secure-2" {
    availability_zone = "eu-west-1b"
    vpc_id = "${aws_vpc.rr-vpc.id}"
    cidr_block = "10.0.4.0/24"
    tags = {
        Name = "rr-subnet-secure-2"
    }
}

resource "aws_route_table_association" "d" {
  subnet_id      = "${aws_subnet.rr-subnet-secure-2.id}"
  route_table_id = "${aws_route_table.rr-rtb-secure.id}"
}