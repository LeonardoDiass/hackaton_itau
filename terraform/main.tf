resource "aws_db_instance" "ephemeral_rds" {
  allocated_storage     = 20                  # Tamanho do armazenamento (GB)
  engine                = "postgresql"             # Ou "postgresql", "mariadb", etc.
  engine_version        = "8.0.35"            # Versão do motor do DB
  instance_class        = "db.t3.micro"       # Tipo da instância (mínimo para testes)
  identifier            = "${var.env_name}-db" # Identificador único para o novo RDS
  username              = "admin"             # Usuário principal (CUIDADO: usar Secrets Manager em prod)
  password              = "MySecurePassword123" # Senha principal (CUIDADO: usar Secrets Manager em prod)
  # db_subnet_group_name  = "your-db-subnet-group" # Se tiver um grupo de subnets para RDS
  vpc_security_group_ids = [aws_security_group.ephemeral_sg.id]
  snapshot_identifier   = var.source_db_snapshot_identifier # RESTAURA DO SNAPSHOT
  skip_final_snapshot   = true # NÃO CRIA SNAPSHOT FINAL AO DESTRUIR (bom para ambientes efêmeros)

  tags = {
    Name        = "${var.env_name}-db"
    Environment = var.env_name
  }
}