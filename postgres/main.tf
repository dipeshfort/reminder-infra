variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "pg_database_name" {}
variable "pg_master_username" {}
variable "pg_master_password" {}

provider "aws" {
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
  region = "eu-west-1"
}
data "aws_vpc" "rr-vpc" {
    tags = {
        Name = "rr-vpc"
    } 
}

data "aws_subnet_ids" "db-subnets" {
  vpc_id = "${data.aws_vpc.rr-vpc.id}"
  tags = {
    Name = "rr-subnet-secure-*"
  }
}

resource "aws_security_group" "rr-db-sg" {
  name   = "rr-db-sg"
  vpc_id = "${data.aws_vpc.rr-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Http access from anywhere
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



########################
## Cluster
########################

resource "aws_rds_cluster" "aurora_cluster" {

    cluster_identifier            = "rr-aurora-cluster"
    database_name                 = "${var.pg_database_name}"
    master_username               = "${var.pg_master_username}"
    master_password               = "${var.pg_master_password}"
    backup_retention_period = 1
    db_subnet_group_name          = "${aws_db_subnet_group.aurora_subnet_group.name}"
    skip_final_snapshot = true
    final_snapshot_identifier     = "rr-aurora-cluster"
    vpc_security_group_ids        = [
        "${aws_security_group.rr-db-sg.id}"
    ]
    port = 5432
    engine = "aurora-postgresql"
    engine_version = "9.6.6"
    tags {
        Name         = "rr-Aurora-DB-Cluster"
    }

    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_rds_cluster_instance" "aurora_cluster_instance" {
    count                 = 1
    identifier            = "rr-aurora-cluster-instance-${count.index}"
    cluster_identifier    = "${aws_rds_cluster.aurora_cluster.id}"
    db_subnet_group_name  = "${aws_db_subnet_group.aurora_subnet_group.name}"
    publicly_accessible   = true
    instance_class = "db.r4.large"
    engine = "aurora-postgresql"
    engine_version = "9.6.6"


    tags {
        Name         = "rr-Aurora-DB-Instance-${count.index}"
    }

    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_db_subnet_group" "aurora_subnet_group" {

    name          = "rr_aurora_db_subnet_group"
    description   = "Allowed subnets for Aurora DB cluster instances"
    subnet_ids    = ["${data.aws_subnet_ids.db-subnets.ids}"]

    tags {
        Name         = "rr-Aurora-DB-Subnet-Group"
    }

}

########################
## Output
########################


output "endpoint" {
  value = "${aws_rds_cluster.aurora_cluster.endpoint}"
} 
