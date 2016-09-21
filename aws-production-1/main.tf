module "aws_az_1b" {
  source = "../modules/aws_az"

  az = "1b"
  bastion_ami = "${var.aws_bastion_ami}"
  bastion_config = "${file("${path.module}/config/bastion-env")}"
  env = "${var.env}"
  gateway_id = "${aws_internet_gateway.gw.id}"
  nat_ami = "${var.aws_nat_ami}"
  nat_instance_type = "c3.8xlarge"
  public_subnet = "10.2.1.0/24"
  vpc_id = "${aws_vpc.main.id}"
  workers_com_subnet = "10.2.3.0/24"
  workers_org_subnet = "10.2.2.0/24"
}

module "aws_az_1e" {
  source = "../modules/aws_az"

  az = "1e"
  bastion_ami = "${var.aws_bastion_ami}"
  bastion_config = "${file("${path.module}/config/bastion-env")}"
  env = "${var.env}"
  gateway_id = "${aws_internet_gateway.gw.id}"
  nat_ami = "${var.aws_nat_ami}"
  nat_instance_type = "c3.8xlarge"
  public_subnet = "10.2.4.0/24"
  vpc_id = "${aws_vpc.main.id}"
  workers_com_subnet = "10.2.6.0/24"
  workers_org_subnet = "10.2.5.0/24"
}

module "aws_asg_org" {
  source = "../modules/aws_asg"

  cyclist_auth_tokens = "${var.cyclist_auth_tokens}"
  cyclist_version = "v0.1.0"
  env = "${var.env}"
  heroku_org = "${var.aws_heroku_org}"
  index = "${var.index}"
  security_groups = "${module.aws_az_1b.workers_org_security_group_id},${module.aws_az_1e.workers_org_security_group_id}"
  site = "org"
  syslog_address = "${var.syslog_address}"
  worker_ami = "${var.aws_worker_ami}"
  worker_asg_max_size = "1" # TODO: remove limit for real deployment
  worker_asg_min_size = "1" # TODO: remove limit for real deployment
  worker_asg_namespace = "Travis/org"
  worker_asg_scale_in_threshold = "16" # TODO: remove limit for real deployment
  worker_asg_scale_out_threshold = "8" # TODO: remove limit for real deployment
  worker_config = "${file("${path.module}/config/worker-env-org")}"
  worker_docker_image_android = "${var.worker_docker_image_android}"
  worker_docker_image_default = "${var.worker_docker_image_default}"
  worker_docker_image_erlang = "${var.worker_docker_image_erlang}"
  worker_docker_image_go = "${var.worker_docker_image_go}"
  worker_docker_image_haskell = "${var.worker_docker_image_haskell}"
  worker_docker_image_jvm = "${var.worker_docker_image_jvm}"
  worker_docker_image_node_js = "${var.worker_docker_image_node_js}"
  worker_docker_image_perl = "${var.worker_docker_image_perl}"
  worker_docker_image_php = "${var.worker_docker_image_php}"
  worker_docker_image_python = "${var.worker_docker_image_python}"
  worker_docker_image_ruby = "${var.worker_docker_image_ruby}"
  worker_docker_self_image = "quay.io/travisci/worker:v2.4.0-23-g396d039"
  worker_subnets = "${module.aws_az_1b.workers_org_subnet_id},${module.aws_az_1e.workers_org_subnet_id}"
}

module "aws_asg_com" {
  source = "../modules/aws_asg"

  cyclist_auth_tokens = "${var.cyclist_auth_tokens}"
  cyclist_version = "v0.1.0"
  env = "${var.env}"
  heroku_org = "${var.aws_heroku_org}"
  index = "${var.index}"
  security_groups = "${module.aws_az_1b.workers_com_security_group_id},${module.aws_az_1e.workers_com_security_group_id}"
  site = "com"
  syslog_address = "${var.syslog_address}"
  worker_ami = "${var.aws_worker_ami}"
  worker_asg_max_size = "1" # TODO: remove limit for real deployment
  worker_asg_min_size = "1" # TODO: remove limit for real deployment
  worker_asg_namespace = "Travis/com"
  worker_asg_scale_in_threshold = "16" # TODO: remove limit for real deployment
  worker_asg_scale_out_threshold = "8" # TODO: remove limit for real deployment
  worker_config = "${file("${path.module}/config/worker-env-com")}"
  worker_docker_image_android = "${var.worker_docker_image_android}"
  worker_docker_image_default = "${var.worker_docker_image_default}"
  worker_docker_image_erlang = "${var.worker_docker_image_erlang}"
  worker_docker_image_go = "${var.worker_docker_image_go}"
  worker_docker_image_haskell = "${var.worker_docker_image_haskell}"
  worker_docker_image_jvm = "${var.worker_docker_image_jvm}"
  worker_docker_image_node_js = "${var.worker_docker_image_node_js}"
  worker_docker_image_perl = "${var.worker_docker_image_perl}"
  worker_docker_image_php = "${var.worker_docker_image_php}"
  worker_docker_image_python = "${var.worker_docker_image_python}"
  worker_docker_image_ruby = "${var.worker_docker_image_ruby}"
  worker_docker_self_image = "quay.io/travisci/worker:v2.4.0-23-g396d039"
  worker_subnets = "${module.aws_az_1b.workers_com_subnet_id},${module.aws_az_1e.workers_com_subnet_id}"
}
