
resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]


  user_data = <<-EOS
            #!/bin/bash
            set -xe

            # Update & install nginx
            dnf -y update
            dnf -y install nginx
            systemctl enable nginx

            # Get IMDSv2 token
            TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
              -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

            # Query instance metadata using the token
            INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
            INSTANCE_TYPE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-type)
            LOCAL_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)
            PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)
            AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

            # Write custom index.html
            cat > /usr/share/nginx/html/index.html <<EOT
            <!doctype html>
            <html lang="en">
            <head>
              <meta charset="utf-8">
              <meta name="viewport" content="width=device-width, initial-scale=1">
              <title>NGINX on EC2 - Demo</title>
            </head>
            <body>
              <h1 style="font-family: sans-serif;">Server is Running</h1>
              <p>This is a simple HTTP demo server provisioned with Terraform.</p>
              <ul>
                <li><b>Instance ID:</b> $INSTANCE_ID</li>
                <li><b>Instance Type:</b> $INSTANCE_TYPE</li>
                <li><b>Private IP:</b> $LOCAL_IP</li>
                <li><b>Public IP:</b> $PUBLIC_IP</li>
                <li><b>Availability Zone:</b> $AZ</li>
              </ul>
            </body>
            </html>
            EOT

            systemctl start nginx
            EOS

  tags = {
    Name = "${var.project}-web"
  }
}
