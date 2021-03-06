module "activate-mozilla-community" {
  source              = "git://github.com/mozilla/partinfra-terraform-cloudfrontssl.git"

  origin_domain_name  = "mozilla.github.io"
  origin_path         = "/activate.mozilla.community"
  origin_id           = "gh-pages-activate-mozilla-community"
  alias               = "activate.mozilla.community"
  comment             = "Bug 1287738"
  acm_certificate_arn = "${lookup(var.ssl_certificates, "mesos-elb-${var.aws_region}")}"
}

module "campus-mozilla-community" {
  source              = "git://github.com/mozilla/partinfra-terraform-cloudfrontssl.git"

  origin_domain_name  = "mozilla.github.io"
  origin_path         = "/mozilla-campus-clubs"
  origin_id           = "gh-pages-campus-mozilla-community"
  alias               = "campus.mozilla.community"
  comment             = "Bug 1301082"
  acm_certificate_arn = "${lookup(var.ssl_certificates, "mesos-elb-${var.aws_region}")}"
}
