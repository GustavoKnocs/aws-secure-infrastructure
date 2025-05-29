# Bucket S3 seguro com criptografia SSE-S3
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "my-bucket-gustavoknocs"  # Altere para um nome único global
  acl    = "private"  # Obsoleto, mas mantido para compatibilidade

  # Bloqueio de acesso público (equivalente ao console)
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Versionamento para recuperação de dados
  versioning {
    enabled = true
  }

  # Criptografia SSE-S3 (padrão do console)
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Configuração de lifecycle para armazenamento inteligente
  lifecycle_rule {
    id      = "logs"
    enabled = true
    prefix  = "ELB-logs/"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"  # Infrequent Access após 30 dias
    }

    expiration {
      days = 365  # Exclui logs após 1 ano
    }
  }

  # Proteção contra exclusão acidental
  lifecycle {
    prevent_destroy = true
  }
}

# Política combinada:
# 1. Força HTTPS
# 2. Permite logs do ELB
# 3. Bloqueia acesso público
resource "aws_s3_bucket_policy" "secure_bucket_policy" {
  bucket = aws_s3_bucket.secure_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # 1. Política para forçar HTTPS
      {
        Sid       = "ForceSSL",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource  = [
          aws_s3_bucket.secure_bucket.arn,
          "${aws_s3_bucket.secure_bucket.arn}/*"
        ],
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      
      # 2. Permissão para ELB (Região: sa-east-1 - São Paulo)
      {
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::033677994240:root"  # Account ID do ELB para sa-east-1
        },
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.secure_bucket.arn}/ELB-logs/AWSLogs/563765640588/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      
      # 3. Bloqueio adicional de acesso público
      {
        Sid       = "DenyPublicAccess",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource  = [
          aws_s3_bucket.secure_bucket.arn,
          "${aws_s3_bucket.secure_bucket.arn}/*"
        ],
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# Configuração de logging (opcional)
resource "aws_s3_bucket_logging" "secure_bucket_logging" {
  bucket = aws_s3_bucket.secure_bucket.id

  target_bucket = aws_s3_bucket.secure_bucket.id  # Auto-logging (pode usar outro bucket)
  target_prefix = "s3-access-logs/"
}

# Outputs úteis
output "s3_bucket_arn" {
  value = aws_s3_bucket.secure_bucket.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.secure_bucket.id
}