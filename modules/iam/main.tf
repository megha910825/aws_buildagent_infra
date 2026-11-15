resource "aws_iam_role" "ba_ec2_role" {
  name = "ba-ec2-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
# 2. Attach Permissions to the Role (Example: Read-only S3 access)
resource "aws_iam_role_policy_attachment" "s3_read_only" {
  role       = aws_iam_role.ba_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
# 3. Create the Instance Profile and link the IAM Role
resource "aws_iam_instance_profile" "ba_ec2_profile" {
  name = "ba-ec2-app-profile"
  role = aws_iam_role.ba_ec2_role.name
}
