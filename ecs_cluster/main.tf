module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"

  cluster_name = "${var.environment}-cluster"
  
  autoscaling_capacity_providers = {
    one = {
      auto_scaling_group_arn         = "arn:aws:autoscaling:eu-central-1:099036503771:autoScalingGroup:51c46f4a-1e0b-4c9e-8889-5fbb9bcd2707:autoScalingGroupName/front-shop20231220213547116000000001"
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 5
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 60
      }

      default_capacity_provider_strategy = {
        weight = 60
        base   = 20
      }
    }

 
  }

  tags = {
    Environment = "Test"
    Project = "Front-Shop"
  }
}