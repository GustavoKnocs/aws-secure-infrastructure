# 🔐 Configuração Segura de Buckets S3  

## **Objetivo**  
Criar buckets S3 seguindo as melhores práticas de segurança:  
- Bloqueio de acesso público  
- Criptografia em repâuso e trânsito  
- Versionamento para recuperação de dados  

## **Passo a Passo**  

### **1. Via AWS Console**  
## 1. Criação do Bucket
![Seleção de Região e Regras de Nomeação](assets\screenshots\S3\01-bucket_creation.png)
*Figura 1: Escolha da região SA-East-1 (São Paulo) e nome "my-security-bucket-S3" escolhido*

## 2. Configurações de Segurança
![Bloqueio de Acesso Público](assets\screenshots\S3\02-block-public-access.png)
*Figura 2: Ativada todas as opções de bloqueio*

## 3. Versionamento
![Versionamento Habilitado](assets\screenshots\S3\03-versioning-settings.png)
*Figura 3: Ative para proteção contra exclusão acidental*

## 4. Criptografia
![Tipos de Criptografia](assets\screenshots\S3\04-encrypition-types.png)
*Figura 4: SSE-S3 (recomendado para starters)*

## 5. Bucket Policy
![Política HTTPS]()
*Figura 5: Restringindo o acesso de solicitações HTTP ao bucket*


### **2. Via Terraform**  

▶️ [Exemplo completo aqui](terraform\modules\secure-s3\main.tf).  

## **Verificações Pós-Criação**  
1. Teste de acesso público:  
   ```sh
   curl https://nome-bucket.s3.amazonaws.com
   # Deve retornar 403 Access Denied
   ```  
2. Audit logs:  
   ```sh
   aws s3api get-bucket-logging --bucket nome-bucket
   ```  