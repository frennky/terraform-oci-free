resource "oci_load_balancer" "free_lb" {
  compartment_id = oci_identity_compartment.free_compartment.id
  display_name   = "${var.prefix}LoadBalancer"
  shape          = "flexible"
  is_private     = false

  subnet_ids = [
    oci_core_subnet.free_public_subnet.id
  ]

  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }

  freeform_tags = local.default_tags
}

resource "oci_load_balancer_ssl_cipher_suite" "free_ssl_cs" {
  load_balancer_id = oci_load_balancer.free_lb.id
  name             = "${var.prefix}_cipher"

  ciphers = ["AES128-SHA", "AES256-SHA"]
}

resource "oci_load_balancer_backend_set" "free_lb_bes" {
  load_balancer_id = oci_load_balancer.free_lb.id
  name             = "${var.prefix}_lb_bes"
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "TCP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_listener" "free_lb_listener" {
  load_balancer_id         = oci_load_balancer.free_lb.id
  default_backend_set_name = oci_load_balancer_backend_set.free_lb_bes.name
  name                     = "${var.prefix}_https"
  port                     = 443
  protocol                 = "HTTP"

  ssl_configuration {
    certificate_ids                   = [oci_certificates_management_certificate.free_cert.id]
    trusted_certificate_authority_ids = [oci_certificates_management_certificate_authority.free_ca.id]
    verify_peer_certificate           = false
    protocols                         = ["TLSv1.1", "TLSv1.2"]
    server_order_preference           = "ENABLED"
    cipher_suite_name                 = oci_load_balancer_ssl_cipher_suite.free_ssl_cs.name
  }
}
