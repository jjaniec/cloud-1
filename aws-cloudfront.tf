resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "s3 static content OAI"
}

resource "aws_cloudfront_distribution" "main" {
  enabled          = true
  retain_on_delete = true

  # origin {
  #   origin_id = "${aws_lb.front.id}-lb"
  #   domain_name = aws_lb.front.dns_name

  #   custom_origin_config {
  #     http_port = 80
  #     https_port = 443
  #     origin_protocol_policy = "http-only"
  #     origin_ssl_protocols = ["TLSv1.2", "SSLv3"]
  #   }
  # }

  origin {
    domain_name = aws_s3_bucket.static.bucket_regional_domain_name
    origin_id   = "${aws_s3_bucket.static.bucket}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "POST", "OPTIONS", "PUT", "PATCH", "DELETE", "HEAD"]
    cached_methods         = ["GET", "OPTIONS", "HEAD"]
    target_origin_id       = "${aws_s3_bucket.static.bucket}"
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    forwarded_values {
      # query_string = true
      query_string = false
      # headers      = ["*"]

      cookies {
        # forward = "all"
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
