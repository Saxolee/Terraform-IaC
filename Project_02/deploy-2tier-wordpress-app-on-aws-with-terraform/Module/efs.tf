resource "aws_efs_file_system" "sts_efs_volume" {
    creation_token = "efs_volume"
}

resource "aws_efs_mount_target" "sts_efs_mount_target_1" {
    file_system_id  = aws_efs_file_system.sts_efs_volume.id
    subnet_id       = aws_subnet.sts_ec2_1_pub_subnet.id
    security_groups = [aws_security_group.sts_efs_sg.id]
}

resource "aws_efs_mount_target" "sts_efs_mount_target_2" {
    file_system_id  = aws_efs_file_system.sts_efs_volume.id
    subnet_id       = aws_subnet.sts_ec2_2_pub_subnet.id
    security_groups = [aws_security_group.sts_efs_sg.id]
}

resource "tls_private_key" "ssh" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "sts_aws_ec2_access_key" {
    key_name_prefix = "sts_efs_key"
    public_key      = tls_private_key.ssh.public_key_openssh
}

resource "local_file" "private_key" {
    content  = tls_private_key.ssh.private_key_pem
    filename = var.private_key_location
}

data "aws_instances" "sts_prod_instances" {
    instance_tags = {
        "Name" = "production-instance"
    }

    depends_on = [
        aws_instance.sts_prod_1_instance,
        aws_instance.sts_prod_2_instance
    ]
}

resource "null_resource" "install_script" {
    count = 2

    depends_on = [
        aws_db_instance.sts_rds_master,
        local_file.private_key,
        aws_efs_mount_target.sts_efs_mount_target_1,
        aws_efs_mount_target.sts_efs_mount_target_2,
        aws_instance.sts_prod_1_instance,
        aws_instance.sts_prod_2_instance
    ]

    connection {
        type        = "ssh"
        host        = data.aws_instances.sts_prod_instances.public_ips[count.index][1][0]
        user        = "ec2-user"
        inline = [
            "sudo yum update -y",
            "sudo yum install docker -y",
            "wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)",
            "sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose",
            "sudo chmod -v +x /usr/local/bin/docker-compose",
            "sudo systemctl enable docker.service",
            "sudo systemctl start docker.service",
            "sudo yum -y install amazon-efs-utils",
            "sudo mkdir -p ${var.mount_directory}",
            "sudo mount -t efs -o tls ${aws_efs_file_system.sts_efs_volume.id}:/ ${var.mount_directory}",
            "sudo docker run --name wordpress-docker -e WORDPRESS_DB_USER=${aws_db_instance.sts_rds_master.username} -e WORDPRESS_DB_HOST=${aws_db_instance.sts_rds_master.endpoint} -e WORDPRESS_DB_PASSWORD=${aws_db_instance.sts_rds_master.password} -v ${var.mount_directory}:${var.mount_directory} -p 80:80 -d wordpress:4.8-apache",
        ]
    }
}