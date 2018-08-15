
resource "aws_ecs_cluster" "rr-secure-cluster" {
    name = "${var.ecs_secure_cluster}"
}

resource "aws_launch_configuration" "ecs-secure-launch-config" {
    name                        = "ecs-secure-launch-config"
    image_id                    = "ami-0612d1ef7f8e72c06"
    instance_type               = "t2.micro"
    iam_instance_profile        = "${aws_iam_instance_profile.ecs-instance-profile.id}"

    root_block_device {
      volume_type = "standard"
      volume_size = 20
      delete_on_termination = true
    }

    lifecycle {
      create_before_destroy = true
    }

    security_groups             = ["${aws_security_group.rr-ec2-sg.id}"]
    associate_public_ip_address = "true"
    key_name                    = "rr-ec2-user"
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.ecs_secure_cluster} >> /etc/ecs/ecs.config
                                  EOF
}

resource "aws_autoscaling_group" "ecs-secure-asg" {
    name                        = "ecs-secure-asg"
    max_size                    = "2"
    min_size                    = "2"
    desired_capacity            = "2"
    vpc_zone_identifier         = ["${aws_subnet.rr-subnet-secure-1.id}", "${aws_subnet.rr-subnet-secure-2.id}"]
    launch_configuration        = "${aws_launch_configuration.ecs-secure-launch-config.name}"
    health_check_type           = "ELB"
}