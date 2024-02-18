resource "aws_instance" "web" {
    ami           = "ami-010c2d0fd8c55129c"
    instance_type = "t2micro"
    vpc_security_group_ids = [aws_secutity_group.roboshop-all.id]
    tags = {
        Name = "provisioner"
    }

    # provisioner "local-exec" {
    #   command = "echo the server's IP address is ${self.private_ip}" # self = aws_instance.web
    # }
    provisioner "local-exec" {
        command = "echo ${self.private_ip} > inventory"
    }

    provisioner "local-exec" {
        command = "echo this will execute at the time of creation, you can trigger other system like email and sending alerts"
    }

    provisioner "local-exec" {
        command ="echo this will execute at the time of destroy, you can trigger other system like email and sending alerts"
        when = destroy
    }

    # provisioner "local-exec" {
    #     command = "ansible-playbook -i inventory web.yaml"
    #     on_failure = continue  # fail
    # }

    connection {
        type     = "ssh"
        user     = "centos"
        password = "DevOps321"
        host     = self.public_ip
    }

    provisioner "remote-exec"{
        inline =[
            "echo 'this is remote exec' > /tmp/remote.txt",
            "sudo yum install nginx -y",
            "sudo system ctl start nginx "
        ]
    }
}

resource "aws_security_group" "roboshop-all" {
    name = "provisioner"
    #description = "allowing to connect from laptop"
    
    ingress {
        description = "Allow All ports"
        from_port   =  22 
        to_port     =  22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

     ingress {
        description = "Allow All ports"
        from_port   =  80 
        to_port     =  80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port    = 0
        to_port      = 0
        protocol     = "-1"
        cidr_blocks  = ["0.0.0.0/0"]   
    }

    tags = {
        Name = "provisioner"
    }
}