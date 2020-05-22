provider "aws"{
    region = "${var.region}"
}

data "template_file" "policy" {
    template = "${file("policy.json")}"

    vars {
        bucket_name = "${var.dominio}"
    }
}
