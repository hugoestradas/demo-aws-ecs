resource "aws_db_instance" "db" {
  engine            = "${var.rds_engine}"
  engine_version    = "${var.rds_engine_version}"
  identifier        = "${var.rds_identifier}"
  instance_class    = "${var.rds_instance_type}"
  allocated_storage = "${var.rds_storage_size}"
  name              = "${var.rds_db_name}"
  username          = "${var.rds_admin_user}"
  password          = "${var.rds_admin_password}"
  publicly_accessible    = "${var.rds_publicly_accessible}"
  vpc_security_group_ids = ["${aws_security_group.rds_security_group.id}"]
  final_snapshot_identifier = "demo-db-backup"
  skip_final_snapshot       = true

  # commented : if there is no default subnet, this will give us an error
  db_subnet_group_name   = "rds_demo_pg"
}

resource "aws_db_subnet_group" "rds_test" {
  name       = "rds_demo_pg"
  subnet_ids                   = ["${aws_subnet.db_a.id}", "${aws_subnet.db_b.id}"]

}