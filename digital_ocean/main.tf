variable "do_token" {}
variable "warrior_project" {}
variable "warrior_concurrency" {}
variable "warrior_downloader" {}
variable "warriors_per_host" {}
variable "do_ssh_keys" {}
variable "do_hosts" {}
variable "do_region" {}
variable "do_host_type" {}

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

variable "instance_name_prefix" {
  default = "archive-team"
}

data "template_file" "warrior_start_script" {
  template = file("start.sh")

  vars = {
    warriors = var.warriors_per_host
    downloader = var.warrior_downloader
    concurrent_items = var.warrior_concurrency
    project = var.warrior_project
  }
}

resource "digitalocean_droplet" "archiveteam" {
  image  = "docker-18-04"
  name   = "${var.instance_name_prefix}-warrior-${count.index}"
  region = var.do_region
  size   = var.do_host_type
  count  = var.do_hosts
  ssh_keys = split(",", var.do_ssh_keys)
}

resource "null_resource" "warrior" {
  count  = var.do_hosts

  triggers = {
    host = digitalocean_droplet.archiveteam.*.id[count.index]
    start_file = sha1(data.template_file.warrior_start_script.rendered)
  }

  connection {
    host = element(digitalocean_droplet.archiveteam.*.ipv4_address, count.index)
  }

  provisioner "file" {
    content = data.template_file.warrior_start_script.rendered
    destination = "/tmp/start.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/start.sh",
      "/tmp/start.sh",
    ]
  }
}

output "ips" {
  value = digitalocean_droplet.archiveteam.*.ipv4_address
}

