# Create the first ec2 production instance
resource "aws_instance" "sts_prod_1_instance" {
    ami                    = var.ami
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.sts_ec2_1_pub_subnet.id
    vpc_security_group_ids = [aws_security_group.sts-prod-instance-sg.id]
    key_name               = aws_key_pair.sts_aws_ec2_access_key.id
    tags = {
        Name = "sts-production-instance-1"
    }
    depends_on = [
        aws_db_instance.sts_rds_master,
    ]
}

# Create the second ec2 production instance
resource "aws_instance" "sts_prod_2_instance" {
    ami                    = var.ami
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.sts_ec2_2_pub_subnet.id
    vpc_security_group_ids = [aws_security_group.sts-prod-instance-sg.id]
    key_name               = aws_key_pair.sts_aws_ec2_access_key.id
    tags = {
        Name = "sts-production-instance-2"
    }
    depends_on = [
        aws_db_instance.sts_rds_master,
    ]
}

# Create a database subnet group
resource "aws_db_subnet_group" "sts_db_subnet" {
  name       = "db subnet"
  subnet_ids = [aws_subnet.sts_db_prv_subnet.id, aws_subnet.sts_db_read_replica_prv_subnet.id]
}

# Create a master rds database instance
resource "aws_db_instance" "sts_rds_master" {
    identifier              = "sts-master-rds-instance"
    allocated_storage       = 10
    engine                  = "mysql"
    engine_version          = "5.7.37"
    instance_class          = "db.t3.micro"
    db_name                 = var.db_name
    username                = var.db_user
    password                = var.db_password
    backup_retention_period = 7
    multi_az                = false
    availability_zone       = var.availability_zone[1]
    db_subnet_group_name    = aws_db_subnet_group.sts_db_subnet.id
    skip_final_snapshot     = true
    vpc_security_group_ids  = [aws_security_group.sts-db-sg.id]
    storage_encrypted       = true
    tags = {
        Name = "sts-rds-master"
    }
}

# Create a rds database replica
resource "aws_db_instance" "sts_rds_replica" {
    replicate_source_db    = aws_db_instance.sts_rds_master.identifier
    instance_class         = "db.t3.micro"
    identifier             = "sts-replica-rds-instance"
    allocated_storage      = 10
    skip_final_snapshot    = true
    multi_az               = false
    availability_zone      = var.availability_zone[0]
    vpc_security_group_ids = [aws_security_group.sts-db-sg.id]
    storage_encrypted      = true
    tags = {
        Name = "sts-rds-replica"
    }
}