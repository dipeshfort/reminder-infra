

resource "aws_alb" "rr-alb-dmz" {
    name = "rr-alb-dmz"
    subnets = ["${aws_subnet.rr-subnet-dmz-1.id}", "${aws_subnet.rr-subnet-dmz-2.id}"]
    security_groups = ["${aws_security_group.rr-alb-sg.id}"]
    tags {
        Name = "rr-alb-dmz"
    }
}

resource "aws_alb_target_group" "rr-alb-dmz-tg" {
    name                = "rr-alb-dmz-tg"
    port                = "80"
    protocol            = "HTTP"
    vpc_id              = "${aws_vpc.rr-vpc.id}"

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }

    tags {
      Name = "rr-alb-dmz-tg"
    }
}
resource "aws_alb_listener" "rr-alb-dmz-listener" {
    load_balancer_arn = "${aws_alb.rr-alb-dmz.arn}"
    port              = "80"
    protocol          = "HTTP"
    depends_on = ["aws_alb_target_group.rr-alb-dmz-tg"]

    default_action {
        target_group_arn = "${aws_alb_target_group.rr-alb-dmz-tg.arn}"
        type             = "forward"
    }
}
