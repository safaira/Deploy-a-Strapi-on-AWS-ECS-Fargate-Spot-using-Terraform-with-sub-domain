resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}


data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_secret_permission" {
  name        = "ecs-secret-permission"
  description = "Policy to allow ECS tasks to access Docker Hub credentials"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "kms:Decrypt"
        ],
        Resource = [
          "arn:aws:secretsmanager:ap-south-1:687157172064:secret:DOCKERHUB_PASSWORD",
          "arn:aws:secretsmanager:ap-south-1:687157172064:secret:DOCKERHUB_USERNAME",
          "arn:aws:kms:ap-south-1:687157172064:key/4806d5f3-2615-4ddf-a3a6-c36c9bf72570"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
                
}
resource "aws_iam_role_policy_attachment" "ecs_secret_permission_attachment" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "aws_iam_policy.ecs_secret_permission.arn"
}