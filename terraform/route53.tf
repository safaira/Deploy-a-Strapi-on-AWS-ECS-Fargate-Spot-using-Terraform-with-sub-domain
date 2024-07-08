# Create Route 53 record
resource "aws_route53_record" "example" {
  zone_id = var.route53_zone_id
  name    = "saniya.superiorwires.com"
  type    = "A"
  alias {
    name                   = aws_ecs_service.nginx.name
    zone_id                = var.route53_zone_id
    evaluate_target_health = true
  }
}