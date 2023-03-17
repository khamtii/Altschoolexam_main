variable "region" {
  type    = string
  default = "us-east-1"
}

variable "inbound_ports" {
  type    = list(any)
  default = [80, 443, 3000, 8080, 9090]
}

variable "jenkins_admin_user" {
  type    = string
  default = "admin"
}

variable "jenkins_admin_password" {
  type    = string
  default = "password"
}
