module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"

  cluster_name = "${var.environment}-cluster"
  
  default_capacity_provider_use_fargate = false
  autoscaling_capacity_providers = {
    ex_1 = {
      auto_scaling_group_arn         = "${var.asgroup_arn}"
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 2
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