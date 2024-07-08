resource "aws_ecs_cluster" "cluster" {
  name = "aws-ecs-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_task_definition" "strapi" {
  family = "strapi"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode = "awsvpc"
  cpu       = 512
  memory    = 1024 # 1 GB

  container_definitions = jsonencode([
    {
      name      = "strapiapp"
      image     = "docker.io/saniyashaikh/strapi:latest",
      # repositoryCredentials: {
      #   credentialsParameter = [ "arn:aws:ssm:ap-south-1:687157172064:parameter/DOCKERHUB_PASSWORD",
      #                            "arn:aws:ssm:ap-south-1:687157172064:parameter/DOCKERHUB_USERNAME"]
        # }
      cpu       = 512
      memory    = 1024 # 1 GB
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
    },
  ])
}


resource "aws_ecs_task_definition" "nginx" {
  family = "nginx"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode = "awsvpc"
  cpu       = 512
  memory    = 1024 # 1 GB

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "docker.io/saniyashaikh/nginx-ssl:1",
      cpu       = 512
      memory    = 1024 # 1 GB
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        },
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
    },
])
}

resource "aws_ecs_service" "strapi" {
  name               = "strapi"
  cluster            = aws_ecs_cluster.cluster.id
  platform_version   = "LATEST"
  launch_type        = "FARGATE"
  task_definition    = aws_ecs_task_definition.strapi.arn
  desired_count      = 1
  #  depends_on       = [aws_iam_role_policy.foo]

  # load_balancer {
  #   target_group_arn = aws_lb_target_group.lb_tg.arn
  #   container_name   = aws_ecs_task_definition.ecs_task.family
  #   container_port   = 1337
  # }

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg_grp.id]
    subnets          = [aws_subnet.subnet1.id]
  }
}

resource "aws_ecs_service" "nginx" {
  name               = "nginx"
  cluster            = aws_ecs_cluster.cluster.id
  platform_version   = "LATEST"
  launch_type        = "FARGATE"
  task_definition    = aws_ecs_task_definition.nginx.arn
  desired_count      = 1
  
  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg_grp.id]
    subnets          = [aws_subnet.subnet1.id]
  }
}

resource "aws_security_group" "ecs_sg_grp" {
  vpc_id      = aws_vpc.strapi_vpc.id
  description = "Security Group for Strapi Application"
  # ingress {
  #   from_port   = "22"
  #   to_port     = "22"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  # ingress {
  #   from_port   = "1337"
  #   to_port     = "1337"
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "ecs-Strapi-sg"
  }

}

