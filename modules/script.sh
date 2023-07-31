#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<html><head><title>Hello World</title></head><body><h1>Hello World!</h1></body></html>" >> /var/www/html/index.html