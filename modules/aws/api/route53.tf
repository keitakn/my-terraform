data "aws_route53_zone" "api" {
  name = "${var.main_domain_name}"
}

resource "aws_route53_record" "api" {
  zone_id = "${data.aws_route53_zone.api.zone_id}"
  name    = "${lookup(var.sub_domain_name, "${terraform.env}.api_name", var.sub_domain_name["default.api_name"])}"
  type    = "A"

  alias {
    name                   = "${aws_alb.api_alb.dns_name}"
    zone_id                = "${aws_alb.api_alb.zone_id}"
    evaluate_target_health = false
  }
}
