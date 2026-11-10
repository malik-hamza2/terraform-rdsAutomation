# Default VPC aur uske subnets (IDs haath se nahi likhne parte)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.name_prefix}-rds-subnet-group"
  description = "Subnet group for MySQL RDS instance"
  subnet_ids  = data.aws_subnets.default.ids

  tags = {
    Name        = "${var.name_prefix}-rds-subnet-group"
    Environment = var.environment
    Project     = var.project
  }
}

# Security Group
resource "aws_security_group" "rds_sg" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Allow MySQL access from inside the VPC"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "MySQL access from VPC network"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-rds-sg"
    Environment = var.environment
    Project     = var.project
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  identifier        = "${var.name_prefix}-mysql-db"
  engine            = "mysql"
  engine_version    = "8.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "appdb"
  username = var.db_username
  password = var.db_password

  multi_az            = false
  publicly_accessible = false

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:05:00-sun:06:00"

  skip_final_snapshot = true
  deletion_protection = false

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name        = "${var.name_prefix}-mysql-db"
    Environment = var.environment
    Project     = var.project
  }
}