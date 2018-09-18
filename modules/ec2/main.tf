resource "aws_security_group" "web" {
  name = "web-sg"
  vpc_id = "${var.vpc-id}"

  egress {
       from_port = 0
       to_port = 0
       protocol = "-1"
       cidr_blocks = ["0.0.0.0/0"]
     }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9090
    to_port   = 9090
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "app-server-sg"
  }
}


locals{
  ansible-config = <<ANSIBLEDATA

[defaults]

# some basic default values...

inventory      = /etc/ansible/hosts
library        = /usr/share/my_modules/
remote_tmp     = $HOME/.ansible/tmp
local_tmp      = $HOME/.ansible/tmp
forks          = 5
poll_interval  = 15
sudo_user      = root
#ask_sudo_pass = True
#ask_pass      = True
#transport      = smart
remote_port    = 22
#module_lang    = C
#module_set_locale = True

# uncomment this to disable SSH key host checking
host_key_checking = False

# if True, make ansible use scp if the connection type is ssh
# (default is sftp)
scp_if_ssh = True

[selinux]
# file systems that require special treatment when dealing with security context
# the default behaviour that copies the existing context or uses the user default
# needs to be changed to use the file system dependent context.
#special_context_filesystems=nfs,vboxsf,fuse,ramfs

# Set this to yes to allow libvirt_lxc connections to work without SELinux.
libvirt_lxc_noseclabel = yes

ANSIBLEDATA


ansible-host = <<ANSIBLEHOST

[app-server]
127.0.0.1 ansible_connection=local
ANSIBLEHOST
}

locals {
  app-server-userdata = <<USERDATA
#!/bin/bash -xe

git clone https://github.com/frodood/web-app-k8s.git

sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get install ansible -y

echo "${local.ansible-config}" > /etc/ansible/ansible.cfg
echo "${local.ansible-host}" > /etc/ansible/hosts


USERDATA
}

resource "aws_instance" "app-server" {
  ami           = "${var.app_defaults["ami_id"]}"
  instance_type = "${var.app_defaults["instance_type"]}"
  key_name      = "${var.app_defaults["key_name"]}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  subnet_id = "${var.subnet-public}"
  user_data_base64            = "${base64encode(local.app-server-userdata)}"
  associate_public_ip_address = "${var.app_defaults["public_ip"]}"
  tags {
    Name = "app-server"
  }
}
