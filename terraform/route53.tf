# # Create Route 53 record
# resource "aws_route53_record" "subdomain" {
#   zone_id = var.route53_zone_id
#   name    = "saniya.superiorwires.com"
#   type    = "A"
#   ttl     = 300
#   records = [aws_ecs_service.nginx.public_ip]
# #   alias {
# #     name                   = aws_ecs_service.nginx.name
# #     zone_id                = var.route53_zone_id
# #     evaluate_target_health = true
# #   }
# }