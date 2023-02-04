resource "aws_lb_target_group" "nginx_service" {
  name        = "nginx-service-api"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled = true
    path    = "/healthz"
  }

  depends_on = [aws_alb.nginx_service]
}

resource "aws_alb" "nginx_service" {
  name               = "nginx-service-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  security_groups = [
    aws_security_group.http.id,
    aws_security_group.egress_all.id,
  ]

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_alb_listener" "nginx_svc_http" {
  load_balancer_arn = aws_alb.nginx_service.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_service.arn
  }
}