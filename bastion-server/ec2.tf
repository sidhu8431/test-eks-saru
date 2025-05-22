
# resource "aws_instance" "bastion" {
#   ami             = var.ami
#   instance_type   = var.instance_type
#   subnet_id       = element(var.public_subnet_ids, 0)  # Selects the first subnet
#   security_groups = [element(var.sg_id, 0)]  # Selects the first security group
#    key_name = "saru@123"
#   tags = {
#     Name = "bastion-server"
#   }
# }


//  aws eks update-kubeconfig --name <cluster-name> --region <region>
resource "aws_instance" "bastion" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.public_subnet_ids[0]
  security_groups = [var.sg_id[0]]
  key_name        = "saru@123"
  environment       = var.environment

  user_data = base64encode(file("${path.module}/bastion.sh"))

  tags = {
    Name        = "bastion-server-${var.environment}"  # Dynamic naming
    Environment = var.environment
  }
}

