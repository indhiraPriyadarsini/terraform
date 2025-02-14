data "aws_ami" "latest_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "null_resource" "wait_for_directory" {
  provisioner "remote-exec" {
    inline = [
      "until [ -d /var/www/html ]; do sleep 5; done"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/Users/presidio/new-key.pem")
      host        = aws_instance.ec2_instance[0].public_ip
    }
  }
}

resource "null_resource" "upload_mysql_connection" {
  depends_on = [null_resource.wait_for_directory]

  provisioner "file" {
    source      = "/Users/presidio/Documents/training/terraform/Day-4/mysql-connection.php"
    destination = "/var/www/html/mysql-connection.php"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/Users/presidio/new-key.pem")
      host        = aws_instance.ec2_instance[0].public_ip
    }
  }
}

resource "aws_instance" "ec2_instance" {
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  count                       = var.instance_count
  key_name                    = var.key_name
  security_groups             = var.security_group_ids
  ami                         = var.ami_id == "" ? data.aws_ami.latest_ami.id : var.ami_id
  instance_type               = var.instance_type
  user_data = base64encode(
    <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd php php-mysqlnd mysql
    systemctl start httpd
    systemctl enable httpd
    sudo mkdir -p /var/www/html
    sudo chown -R ec2-user:apache /var/www/html
    sudo chmod -R 775 /var/www/html
    EOF
  )
}
