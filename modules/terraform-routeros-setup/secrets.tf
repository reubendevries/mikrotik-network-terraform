data "aws_secretsmanager_secret" "crs326_ip" {
  name = "mikrotik/crs326_router_ip"
}

data "aws_secretsmanager_secret" "crs326_username" {
  name = "mikrotik/crs326_username"
}

data "aws_secretsmanager_secret" "crs326_password" {
  name = "mikrotik/crs326_password"
}

data "aws_secretsmanager_secret_version" "crs326_ip" {
  secret_id = data.aws_secretsmanager_secret.crs326_ip.id
}

data "aws_secretsmanager_secret_version" "crs326_username" {
  secret_id = data.aws_secretsmanager_secret.crs326_username.id
}

data "aws_secretsmanager_secret_version" "crs326_password" {
  secret_id = data.aws_secretsmanager_secret.crs326_password.id
}
