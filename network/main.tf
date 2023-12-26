resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.environment}-vpc"
    Environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet.id
  depends_on = [ aws_internet_gateway.gw ]

  tags = {
    Name = "${var.environment}-nat"
  }
}

resource "aws_eip" "nat_eip" {
    depends_on = [ aws_internet_gateway.gw ]
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${var.environment}-private-subnet"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_route_table.public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id = aws_route_table.private_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_route_association" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route53_zone" "main" {
  name = "frontshop.tech"

  tags = {
    Name = "${var.environment}-route53"
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "frontshop.tech"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.main.zone_id
  records = [ tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value ]

  ttl = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}


resource "aws_cloudfront_origin_access_control" "origin_access" {
  name                              = "cloudfront_access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = var.s3_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.origin_access.id
    origin_id = local.s3_origin_id
  }

  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  # aliases = ["frontshop.tech"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT" ]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    
    viewer_protocol_policy = "allow-all"
  }

  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
  }

    custom_error_response {
    error_caching_min_ttl = 300
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }

}



