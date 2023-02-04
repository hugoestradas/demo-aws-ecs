resource "aws_ecs_cluster" "cluster" {
  name = "cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "service"
  execution_role_arn = aws_iam_role.nginx_service_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "nginx-service",
      "image"     : "yovafree/demo-net:employeesapi",
      "cpu"       : 256,
      "memory"    : 512,
      "essential" : true,
      "environment": [
        {"name": "ConnectionStrings__DefaultConnection", "value": "Host=${aws_db_instance.db.address};Port=5432;Database=${var.rds_db_name};Username=${var.rds_admin_user};Password=${var.rds_admin_password}"}
      ],
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort"      : 80
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "us-east-1",
          "awslogs-group": "/ecs/nginx-service",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  DEFINITION
  tags = {
    Name = "nginx-service"
  }

  depends_on = [aws_db_instance.db]
}

resource "aws_cloudwatch_log_group" "nginx_service" {
  name = "/ecs/nginx-service"
}

resource "aws_iam_role" "nginx_service_task_execution_role" {
  name               = "nginx-service-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
  principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Normally we'd prefer not to hardcode an ARN in our Terraform, but since this is
# an AWS-managed policy, it's okay.
data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
# Attach the above policy to the execution role.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.nginx_service_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}

resource "aws_ecs_service" "service" {
  name            = "nginx-service"
  task_definition = aws_ecs_task_definition.task.arn
  cluster         = aws_ecs_cluster.cluster.id
  launch_type     = "FARGATE"
  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_service.arn
    container_name   = var.task_name
    container_port   = "80"
  }
  desired_count = 1
  network_configuration {
   assign_public_ip = false
    security_groups = [
     aws_security_group.egress_all.id,
     aws_security_group.ingress_service.id,
    ]
    subnets = [
     aws_subnet.private_a.id,
     aws_subnet.private_b.id
   ]
 }
}