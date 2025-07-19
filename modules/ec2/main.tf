# Choosing the AMI for the instances
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Creating the two proxy EC2 instances
resource "aws_instance" "proxy" {
  count                  = 2
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [var.proxy_sg_id]
  key_name               = var.key_name

  # A simple script that creates a directory in the proxy machine to store the frontend code
  user_data                   = <<-EOF
              #!/bin/bash
              mkdir -p /home/ec2-user/frontend
              EOF

  # Copying the frontend code from the local machine to the EC2 instance
  provisioner "file" {
    source      = "${path.root}/code/frontend/"
    destination = "./"
  }

  # Installing the needed packages
  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -",
      "sudo yum install -y nodejs",
      "sudo npm install -g serve",
      "cd /home/ec2-user/frontend",
      "npm install",
      "npm run build",
      "nohup serve -s build -l 3000 > react.log 2>&1 &"
    ]
  }

  # Connecting through SSH
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.root}/code/final-project.pem")
    host        = self.public_ip
  }

  tags = {
    Name = "proxy-${count.index + 1}"
  }
}

# Creating the two backend EC2 instances
resource "aws_instance" "backend" {
  count                  = 2
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.backend_sg_id]
  key_name               = var.key_name

  # Installing the packages for the backend and the DB, and copies/syncs the file to the S3 bucket
  user_data = <<-EOF
  #!/bin/bash
  mkdir -p /home/ec2-user/backend
  cd /home/ec2-user/backend
  yum update -y
  yum upgrade -y
  # Install AWS CLI (if not already present)
  sudo yum install -y aws-cli || true
  
  # Copy code from S3 (recommended approach)
  aws s3 sync s3://fp-iti0/backend/ /home/ec2-user/backend/
  
  # Alternative: Download as zip from a web server
  # curl -o /tmp/backend.zip https://your-server.com/backend.zip
  # unzip /tmp/backend.zip -d /home/ec2-user/backend/
  
  # Set proper permissions
  chown -R ec2-user:ec2-user /home/ec2-user/backend
  chmod -R 755 /home/ec2-user/backend
  # MongoDB installation
  tee /etc/yum.repos.d/mongodb-org-6.0.repo <<REPO
  [mongodb-org-6.0]
  name=MongoDB Repository
  baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/6.0/x86_64/
  gpgcheck=1
  enabled=1
  gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc
  REPO
  
  yum install -y mongodb-org
  systemctl start mongod
  systemctl enable mongod
  
  # Node.js installation
  curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
  yum install -y nodejs
  
  # Start backend
  cd /home/ec2-user/backend
  npm install
  nohup npm run start:dev > backend.log 2>&1 &
EOF
  

  tags = {
    Name = "backend-${count.index + 1}"
  }
}
