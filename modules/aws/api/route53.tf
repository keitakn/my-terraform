data "aws_route53_zone" "main" {
  name = var.main_domain_name
}

resource "aws_route53_record" "rest_api" {
  zone_id = data.aws_route53_zone.main.zone_id
  name = lookup(
    var.sub_domain_name,
    "${terraform.workspace}.rest_api",
    var.sub_domain_name["default.rest_api"],
  )
  type = "A"

  alias {
    name                   = aws_alb.rest_api_alb.dns_name
    zone_id                = aws_alb.rest_api_alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "graphql" {
  zone_id = data.aws_route53_zone.main.zone_id
  name = lookup(
    var.sub_domain_name,
    "${terraform.workspace}.graphql",
    var.sub_domain_name["default.graphql"],
  )
  type = "A"

  alias {
    name                   = aws_alb.graphql_alb.dns_name
    zone_id                = aws_alb.graphql_alb.zone_id
    evaluate_target_health = false
  }
}
