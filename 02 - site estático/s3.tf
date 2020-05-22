resource "aws_s3_bucket" "log" {
    bucket = "${var.dominio}-logs"
    acl    = "log-delivery-write"
}
resource "aws_s3_bucket" "site" {
    bucket = "${var.dominio}"
    acl    = "public-read"
    policy = "${data.template_file.policy.rendered}"

    website {
        index_document = "index.html"
        error_document = "error.html"    
    }
    logging {
        target_bucket = "${aws_s3_bucket.log.bucket}"
        target_prefix = "${var.dominio}"
    }
}

resource "aws_s3_bucket" "redirect" {
    bucket = "www.${var.dominio}"
    acl = "public-read"

    website {
        redirect_all_requests_to = "${var.dominio}"
    }
}