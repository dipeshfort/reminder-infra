resource "aws_key_pair" "rr-ec2-user" {
  key_name = "rr-ec2-user"
  public_key = "${var.public_key}"
}
