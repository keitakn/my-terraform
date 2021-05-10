resource "aws_route53_zone" "rds_local_domain_name" {
  name = terraform.workspace

  vpc {
    vpc_id = var.vpc["vpc_id"]
  }

  comment = "${terraform.workspace} RDS Local Domain"

  force_destroy = true
}

resource "aws_route53_record" "rds_local_writer_domain_record" {
  zone_id = aws_route53_zone.rds_local_domain_name.zone_id
  name    = var.rds_local_writer_domain_name
  type    = "CNAME"

  ttl     = 300
  records = [aws_rds_cluster.rds_cluster.endpoint]
}

resource "aws_route53_record" "rds_local_reader_domain_record" {
  zone_id = aws_route53_zone.rds_local_domain_name.zone_id
  name    = var.rds_local_reader_domain_name
  type    = "CNAME"

  ttl     = 300
  records = [aws_rds_cluster.rds_cluster.reader_endpoint]
}
