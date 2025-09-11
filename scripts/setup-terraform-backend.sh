#!/bin/bash

# Script para configurar el backend remoto de Terraform
# Este script debe ejecutarse ANTES del primer deployment

set -e

PROFILE=${1:-personal}
ENVIRONMENT=${2:-prod}
REGION=${3:-us-east-1}

# Configuración del bucket de state
STATE_BUCKET_NAME="bot-finance-terraform-state"
DYNAMODB_TABLE_NAME="bot-finance-terraform-locks"
PROJECT_NAME="bot-finance"

echo "🏗️  Configurando backend remoto de Terraform"
echo "👤 Perfil AWS: $PROFILE"
echo "🌍 Environment: $ENVIRONMENT"
echo "📍 Región: $REGION"
echo "🪣 Bucket de state: $STATE_BUCKET_NAME"
echo "🔒 Tabla de locks: $DYNAMODB_TABLE_NAME"
echo ""

# Función para mostrar ayuda
show_help() {
    echo "📖 USO:"
    echo "  $0 [perfil-aws] [environment] [region]"
    echo ""
    echo "📋 PARÁMETROS:"
    echo "  perfil-aws   Perfil AWS a usar (default: personal)"
    echo "  environment  Ambiente (default: prod)"
    echo "  region       Región AWS (default: us-east-1)"
    echo ""
    echo "💡 EJEMPLOS:"
    echo "  $0                           # Usar defaults"
    echo "  $0 personal prod us-east-1   # Especificar todos los parámetros"
    echo "  $0 bot-finance prod          # Usar perfil bot-finance"
}

# Verificar si se pide ayuda
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
    exit 0
fi

# Verificar credenciales AWS
echo "🔍 Verificando credenciales AWS..."
if ! aws sts get-caller-identity --profile $PROFILE >/dev/null 2>&1; then
    echo "❌ Error: No se pudo verificar credenciales para perfil '$PROFILE'"
    echo "Ejecuta: aws configure --profile $PROFILE"
    exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --profile $PROFILE --query Account --output text)
echo "✅ Conectado a cuenta: $ACCOUNT_ID"
echo ""

# Verificar que jq está instalado
if ! command -v jq &> /dev/null; then
    echo "❌ Error: 'jq' no está instalado. Se necesita para procesar respuestas JSON."
    echo "Instalar con: brew install jq (macOS) o apt-get install jq (Ubuntu)"
    exit 1
fi

# Crear bucket para el state de Terraform
echo "🪣 Configurando bucket de state..."
if aws s3 ls s3://$STATE_BUCKET_NAME --profile $PROFILE >/dev/null 2>&1; then
    echo "✅ Bucket de state ya existe: $STATE_BUCKET_NAME"
else
    echo "📝 Creando bucket de state: $STATE_BUCKET_NAME"
    
    # Crear bucket
    aws s3 mb s3://$STATE_BUCKET_NAME --region $REGION --profile $PROFILE
    
    # Habilitar versionado
    echo "🔄 Habilitando versionado en bucket de state..."
    aws s3api put-bucket-versioning \
        --bucket $STATE_BUCKET_NAME \
        --versioning-configuration Status=Enabled \
        --profile $PROFILE
    
    # Habilitar cifrado por defecto
    echo "🔐 Habilitando cifrado en bucket de state..."
    aws s3api put-bucket-encryption \
        --bucket $STATE_BUCKET_NAME \
        --server-side-encryption-configuration '{
            "Rules": [
                {
                    "ApplyServerSideEncryptionByDefault": {
                        "SSEAlgorithm": "AES256"
                    }
                }
            ]
        }' \
        --profile $PROFILE
    
    # Bloquear acceso público
    echo "🚫 Bloqueando acceso público al bucket de state..."
    aws s3api put-public-access-block \
        --bucket $STATE_BUCKET_NAME \
        --public-access-block-configuration '{
            "BlockPublicAcls": true,
            "IgnorePublicAcls": true,
            "BlockPublicPolicy": true,
            "RestrictPublicBuckets": true
        }' \
        --profile $PROFILE
    
    echo "✅ Bucket de state creado y configurado: $STATE_BUCKET_NAME"
fi

# Crear tabla DynamoDB para locks de Terraform
echo ""
echo "🔒 Configurando tabla de locks..."
if aws dynamodb describe-table --table-name $DYNAMODB_TABLE_NAME --region $REGION --profile $PROFILE >/dev/null 2>&1; then
    echo "✅ Tabla de locks ya existe: $DYNAMODB_TABLE_NAME"
else
    echo "📝 Creando tabla de locks: $DYNAMODB_TABLE_NAME"
    
    aws dynamodb create-table \
        --table-name $DYNAMODB_TABLE_NAME \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --region $REGION \
        --profile $PROFILE \
        --tags '[
            {
                "Key": "Proyecto",
                "Value": "'$PROJECT_NAME'"
            },
            {
                "Key": "Ambiente",
                "Value": "'$ENVIRONMENT'"
            },
            {
                "Key": "Proposito",
                "Value": "terraform-state-locking"
            }
        ]'
    
    echo "⏳ Esperando que la tabla esté disponible..."
    aws dynamodb wait table-exists \
        --table-name $DYNAMODB_TABLE_NAME \
        --region $REGION \
        --profile $PROFILE
    
    echo "✅ Tabla de locks creada: $DYNAMODB_TABLE_NAME"
fi

echo ""
echo "🎉 ¡Backend remoto configurado exitosamente!"
echo ""
echo "📊 RESUMEN:"
echo "• Bucket de state: $STATE_BUCKET_NAME"
echo "• Tabla de locks: $DYNAMODB_TABLE_NAME"
echo "• Región: $REGION"
echo "• Account ID: $ACCOUNT_ID"
echo ""
echo "🔧 CONFIGURACIÓN PARA provider.tf:"
echo ""
echo "terraform {"
echo "  backend \"s3\" {"
echo "    bucket         = \"$STATE_BUCKET_NAME\""
echo "    key            = \"$PROJECT_NAME/$ENVIRONMENT/terraform.tfstate\""
echo "    region         = \"$REGION\""
echo "    encrypt        = true"
echo "    dynamodb_table = \"$DYNAMODB_TABLE_NAME\""
echo "  }"
echo "}"
echo ""
echo "🚀 SIGUIENTES PASOS:"
echo "1. Actualizar environments/$ENVIRONMENT/provider.tf con la configuración de arriba"
echo "2. Ejecutar: terraform init (para migrar al nuevo backend)"
echo "3. Confirmar la migración cuando Terraform pregunte"
echo "4. Ejecutar el deployment normalmente"
echo ""
echo "💡 NOTA: Una vez configurado el backend remoto, todos los deployments"
echo "   mantendrán el estado entre ejecuciones, evitando conflictos."
