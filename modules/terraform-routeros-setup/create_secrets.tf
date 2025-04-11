# create_secrets.tf
resource "aws_secretsmanager_secret" "crs326_ip" {
  name = "mikrotik/crs326_ip"
}

resource "aws_secretsmanager_secret_version" "crs326_ip" {
  secret_id     = aws_secretsmanager_secret.crs326_ip.id
  secret_string = local.crs326_ip
}

resource "aws_secretsmanager_secret" "crs326_username" {
  name = "mikrotik/crs326_username"
}

resource "aws_secretsmanager_secret_version" "crs326_username" {
  secret_id     = aws_secretsmanager_secret.crs326_username.id
  secret_string = local.crs326_username
}

resource "aws_secretsmanager_secret" "crs326_password" {
  name = "mikrotik/crs326_password"
}

resource "aws_secretsmanager_secret_version" "crs326_password" {
  secret_id     = aws_secretsmanager_secret.crs326_password.id
  secret_string = local.crs326_password
}