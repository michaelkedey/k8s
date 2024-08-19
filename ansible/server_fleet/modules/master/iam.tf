# # Create IAM role for bastion host
# resource "aws_iam_role" "bastion_host_role" {
#   name        = var.ssm_host_role
#   description = "Role for bastion host"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Effect = "Allow"
#       }
#     ]
#   })
# }

# # Create IAM ssm policy for bastion host
# resource "aws_iam_policy" "bastion_host_policy" {
#   name        = var.ssm_host_policy
#   description = "Policy for bastion host"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ssm:DescribeSessions",
#           "ssm:GetConnectionStatus",
#           "ssm:StartSession",
#           "ssm:TerminateSession"
#         ]
#         Resource = "*"
#         Effect   = "Allow"
#       },
#       {
#         Action = [
#           "ec2:DescribeInstances"
#         ]
#         Resource = "*"
#         Effect   = "Allow"
#       }
#     ]
#   })
# }

# # Attach policy to role
# resource "aws_iam_role_policy_attachment" "bastion_host_attach" {
#   role       = aws_iam_role.bastion_host_role.name
#   policy_arn = aws_iam_policy.bastion_host_policy.arn
# }

# # Create instance profile for bastion host
# resource "aws_iam_instance_profile" "bastion_host_profile" {
#   name = var.ssm_host_profile
#   role = aws_iam_role.bastion_host_role.name
# }
