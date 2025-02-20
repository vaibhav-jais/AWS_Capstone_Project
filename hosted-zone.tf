# Hosted Zone
resource "aws_route53_zone" "primary" {
  name = "vaibhavcloud.info"

  tags = {
    Name = "vaibhavcloud.info"
  }
}

# A Record (Alias to ALB)
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "vaibhavcloud.info"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

# CNAME Record
resource "aws_route53_record" "cname" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.vaibhavcloud.info"
  type    = "CNAME"
  ttl     = "60"
  records = ["vaibhavcloud.info"]
}
