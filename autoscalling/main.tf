# resource "aws_launch_template" "template" {
#   name_prefix = "${var.environment}"
#   image_id = "ami-024f768332f080c5e"
#   instance_type = "t2.micro"

# }

# resource "aws_autoscaling_group" "autoscalling" {
#   name_prefix = "${var.environment}"
# #   availability_zones = ["eu-central-1"]
#   vpc_zone_identifier = ["${var.private_id}", "${var.public_id}"]
#   desired_capacity = 1
#   max_size = 1
#   min_size = 1

#   launch_template {
#     id = aws_launch_template.template.id
#     version = "$Latest"
#   }
# }


module "autoscalling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.5"

  for_each = {
    # On-demand instances
    ex_1 = {
      instance_type              = "t2.micro"
      use_mixed_instances_policy = false
      mixed_instances_policy     = {}
      key_name = "testkey"
      user_data                  = <<-EOT
        #!/bin/bash

        cat <<'EOF' >> /etc/ecs/ecs.config
        ECS_CLUSTER=${var.cluster_name}
        EOF
      EOT
    }
  }
  name = "${var.environment}-autoscalling"
  protect_from_scale_in = true
  image_id = "ami-0029cbd17e0d653cf"
  instance_type = "t2.micro"

  vpc_zone_identifier = [var.private_id, var.public_id]
  health_check_type   = "EC2"
  min_size            = 1
  max_size            = 3
  desired_capacity    = 3

  autoscaling_group_tags = {
    AmazonECSManaged = true
  }

  create_iam_instance_profile = true
  iam_role_name               = "${var.environment}-role"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

}


# module "autoscaling_sg" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "~> 5.0"

#   name        = "${var.environment}-sg"
#   description = "Autoscaling group security group"
#   vpc_id      = var.vpc_id

#   computed_ingress_with_source_security_group_id = [
#     {
#       rule                     = "http-80-tcp"
#       source_security_group_id = module.alb.security_group_id
#     }
#   ]
#   number_of_computed_ingress_with_source_security_group_id = 1

#   egress_rules = ["all-all"]

# }