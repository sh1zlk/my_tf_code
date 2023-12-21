resource "aws_launch_template" "template" {
  name_prefix = "${var.environment}"
  image_id = "ami-024f768332f080c5e"
  instance_type = "t2.micro"

}

resource "aws_autoscaling_group" "autoscalling" {
  name_prefix = "${var.environment}"
#   availability_zones = ["eu-central-1"]
  vpc_zone_identifier = ["${var.private_id}", "${var.public_id}"]
  desired_capacity = 1
  max_size = 1
  min_size = 1

  launch_template {
    id = aws_launch_template.template.id
    version = "$Latest"
  }
}