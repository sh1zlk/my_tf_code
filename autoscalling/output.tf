# output "asgroup_arn" {
#   value = aws_autoscaling_group.autoscalling.arn
# }

output "asgroup_arn" {
  value = module.autoscalling["ex_1"].autoscaling_group_arn  
}