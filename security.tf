resource "aws_security_group" "worker_mgmt" {
    name_prefix = "all_worker_management"
    vpc_id = module.vpc.vpc_id
ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
cidr_blocks = [
            "10.0.0.0/8"
        ]
    }
}