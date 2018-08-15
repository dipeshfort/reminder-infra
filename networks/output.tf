
output "vpc-id" {
    value = "${aws_vpc.rr-vpc.id}"
}

output "alb-dmz" {
    value = "${aws_alb.rr-alb-dmz.dns_name}"
}
output "alb-secure" {
    value = "${aws_alb.rr-alb-secure.dns_name}"
}