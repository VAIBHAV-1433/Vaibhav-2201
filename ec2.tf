
resource "aws_instance" "Terraform-EC2" {
  ami           = "ami-05b10e08d247fb927" 
  instance_type = "t2.micro"
  key_name      = aws_key_pair.vaibhav.id

  tags = {
    Name = "Terraform-EC2"
  }
}
resource "aws_key_pair" "vaibhav" {
  key_name = "vaibhav"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMRM5WasaT7Bf0WHLjtLjVSXbVhXGAz7zA4N6Mw+TCwN vaibh@LAPTOP-EKOTQ9RF"


  
}

