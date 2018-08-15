resource "aws_instance" "ec2-dmz-1" {
    ami = "ami-0612d1ef7f8e72c06"
    instance_type   = "t2.micro"
    subnet_id = "${aws_subnet.rr-subnet-dmz-1.id}"
    vpc_security_group_ids = ["${aws_security_group.sg-web.id}"]
    key_name = "rr-ec2-user"
    associate_public_ip_address = true
    tags = {
        Name = "Web-1"
    }

    connection = {
        user        = "ec2-user"
        private_key = "${file("../secrets/rr-ec2-user")}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum install nginx -y",
            "sudo service nginx start",
            "echo '<html><head><title>Web 1</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">Web 1</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html"
        ]
    }
}

resource "aws_instance" "ec2-dmz-2" {
    ami = "ami-0612d1ef7f8e72c06"
    instance_type   = "t2.micro"
    subnet_id = "${aws_subnet.rr-subnet-dmz-2.id}"
    vpc_security_group_ids = ["${aws_security_group.sg-web.id}"]
    key_name = "rr-ec2-user"
    associate_public_ip_address = true
    tags = {
        Name = "Web-2"
    }

    connection = {
        user        = "ec2-user"
        private_key = "${file("../secrets/rr-ec2-user")}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum install nginx -y",
            "sudo service nginx start",
            "echo '<html><head><title>Web 2</title></head><body style=\"background-color:crimson\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">Web 2</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html"
        ]
    }
}

output "web-1"{ 
  value = "${aws_instance.ec2-dmz-1.public_dns}"
}
output "web-2"{ 
  value = "${aws_instance.ec2-dmz-2.public_dns}"
}


