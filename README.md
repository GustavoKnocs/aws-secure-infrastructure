# Infraestrutura Segura na AWS ☁️🔐

Este projeto simula uma infraestrutura segura na AWS, com foco em boas práticas de segurança, monitoramento e controle de acesso, utilizando serviços como EC2, S3 e IAM.

## 🔧 Serviços Utilizados

- Amazon EC2 (máquina virtual Linux)
- Amazon S3 (armazenamento de site estático)
- IAM (controle de acesso com políticas customizadas)
- VPC customizada
- CloudTrail (auditoria)
- CloudWatch (monitoramento)

## 🧱 Estrutura

- EC2 em subnet pública com acesso restrito por Security Group
- S3 com bucket privado e acesso controlado por políticas
- IAM com roles e políticas de menor privilégio
- Logging e criptografia ativados

## 📜 Scripts e Políticas

Veja a pasta `scripts/` e `iam-policies/` para exemplos reais.

## 📊 Diagrama da Arquitetura

Veja em 'architecture/diagram.png'

## ✅ Checklist de Segurança

- [x] Princípio do menor privilégio
- [x] Criptografia em repouso (S3 + KMS)
- [x] MFA ativado
- [x] Logging via CloudTrail
- [x] Acesso SSH restrito por IP

## 📚 Aprendizados

- IAM avançado com políticas customizadas
- Monitoramento com CloudWatch
- Infraestrutura segura como base para aplicações web
