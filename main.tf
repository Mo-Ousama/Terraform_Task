provider "aws" {
  region = "us-east-1"  # اختر المنطقة التي تريدها
}

# إنشاء VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "example_vpc"
  }
}

# إنشاء Subnet أولى
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet1"
  }
}

# إنشاء Subnet ثانية
resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet2"
  }
}

# إنشاء Security Group للسماح بـ HTTPS فقط
resource "aws_security_group" "example_sg" {
  vpc_id = aws_vpc.example_vpc.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "example_sg"
  }
}

# إنشاء Instances في Subnet1
resource "aws_instance" "instance1_subnet1" {
  ami           = "ami-0c55b159cbfafe1f0"  # اختر AMI مناسب لمنطقتك
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id
  security_groups = [aws_security_group.example_sg.name]

  provisioner "local-exec" {
    command = "echo Private IP of Instance 1 in Subnet 1: ${self.private_ip}"
  }

  tags = {
    Name = "instance1_subnet1"
  }
}

resource "aws_instance" "instance2_subnet1" {
  ami           = "ami-0c55b159cbfafe1f0"  # اختر AMI مناسب لمنطقتك
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id
  security_groups = [aws_security_group.example_sg.name]

  provisioner "local-exec" {
    command = "echo Private IP of Instance 2 in Subnet 1: ${self.private_ip}"
  }

  tags = {
    Name = "instance2_subnet1"
  }
}

# إنشاء Instances في Subnet2
resource "aws_instance" "instance1_subnet2" {
  ami           = "ami-0c55b159cbfafe1f0"  # اختر AMI مناسب لمنطقتك
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet2.id
  security_groups = [aws_security_group.example_sg.name]

  provisioner "local-exec" {
    command = "echo Private IP of Instance 1 in Subnet 2: ${self.private_ip}"
  }

  tags = {
    Name = "instance1_subnet2"
  }
}

resource "aws_instance" "instance2_subnet2" {
  ami           = "ami-0c55b159cbfafe1f0"  # اختر AMI مناسب لمنطقتك
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet2.id
  security_groups = [aws_security_group.example_sg.name]

  provisioner "local-exec" {
    command = "echo Private IP of Instance 2 in Subnet 2: ${self.private_ip}"
  }

  tags = {
    Name = "instance2_subnet2"
  }
}

# إخراج عناوين الـ IP الخاصة بكل Instance
output "private_ips" {
  value = [
    aws_instance.instance1_subnet1.private_ip,
    aws_instance.instance2_subnet1.private_ip,
    aws_instance.instance1_subnet2.private_ip,
    aws_instance.instance2_subnet2.private_ip
  ]
}
