resource "aws_security_group" "consul-shared-ec2-sg" {
    name        = "consul-shared-ec2-sg"
    description = "Consul SG"
    vpc_id      = "${aws_vpc.apps-shared-vpc.id}"
}

resource "aws_security_group_rule" "consul-shared-ec2-sg-allowallfromprodstaging" {
    type              = "ingress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["${aws_vpc.apps-staging-vpc.cidr_block}", "${aws_vpc.apps-production-vpc.cidr_block}", "${aws_vpc.apps-shared-vpc.cidr_block}"]

    security_group_id = "${aws_security_group.consul-shared-ec2-sg.id}"
}

resource "aws_security_group_rule" "consul-shared-ec2-sg-allowall" {
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.consul-shared-ec2-sg.id}"
}

resource "aws_launch_configuration" "consul-shared-ec2-lc" {
  name_prefix                 = "consul-shared-ec2-lc-"
  image_id                    = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type               = "t2.micro"
  key_name                    = "ansible"
  security_groups             = ["${aws_security_group.consul-shared-ec2-sg.id}"]
  associate_public_ip_address = true
  root_block_device {
    volume_size               = 100
  }
  lifecycle {
    create_before_destroy     = true
  }
}

resource "aws_autoscaling_group" "consul-shared-ec2-as" {
    name                    = "consul-shared-ec2-as"
    launch_configuration    = "${aws_launch_configuration.consul-shared-ec2-lc.id}"
    availability_zones      = ["${split(",", lookup(var.aws_availibility_zones, var.aws_region))}"]
    max_size                = 5
    desired_capacity        = 3
    min_size                = 3
    vpc_zone_identifier     = ["${aws_subnet.apps-shared-1a.id}", "${aws_subnet.apps-shared-1c.id}", "${aws_subnet.apps-shared-1d.id}"]
    tag {
      key                   = "app"
      value                 = "consul"
      propagate_at_launch   = true
    }

    tag {
      key                   = "env"
      value                 = "shared"
      propagate_at_launch   = true
    }
    tag {
      key                   = "Name"
      value                 = "consul"
      propagate_at_launch   = true
    }
    lifecycle {
      create_before_destroy = true
    }
}
