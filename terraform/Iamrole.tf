
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

  inline_policy {
    name = "ecs-ssm-permission"

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
          "arn:aws:ssm:ap-south-1:687157172064:parameter/DOCKERHUB_PASSWORD",
          "arn:aws:ssm:ap-south-1:687157172064:parameter/DOCKERHUB_USERNAME",
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
