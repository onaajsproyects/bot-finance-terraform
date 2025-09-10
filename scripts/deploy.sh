#!/bin/bash

# Script de deployment para el repositorio de infraestructura
set -e

ENVIRONMENT=${1:-prod}
PROJECT_NAME="bot-finance"

echo "🚀 Desplegando infraestructura para ambiente: $ENVIRONMENT"

# Verificar prerrequisitos
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform no está instalado"
    exit 1
fi

if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI no está instalado"
    exit 1
fi

# Verificar credenciales AWS
if ! aws sts get-caller-identity >/dev/null 2>&1; then
    echo "❌ No hay credenciales de AWS configuradas"
    echo "Ejecuta: aws configure"
    exit 1
fi

# Solicitar token de Telegram si no está en variables de entorno
if [ -z "$TG_BOT_TOKEN" ]; then
    echo "🤖 Ingresa el token del bot de Telegram:"
    read -s TG_BOT_TOKEN
    export TG_BOT_TOKEN
fi

# Ir al directorio del ambiente
cd "environments/$ENVIRONMENT"

# Verificar que existe terraform.tfvars
if [ ! -f "terraform.tfvars" ]; then
    echo "📝 Creando terraform.tfvars desde ejemplo..."
    if [ -f "terraform.tfvars.example" ]; then
        cp terraform.tfvars.example terraform.tfvars
        echo "⚠️  Edita terraform.tfvars con tus valores antes de continuar"
        echo "Presiona Enter cuando esté listo..."
        read
    else
        echo "❌ No existe terraform.tfvars.example"
        exit 1
    fi
fi

# Inicializar Terraform
echo "🔧 Inicializando Terraform..."
terraform init

# Validar configuración
echo "✅ Validando configuración..."
terraform validate

# Planificar deployment
echo "📋 Generando plan de deployment..."
terraform plan -var="telegram_token=$TG_BOT_TOKEN" -out=tfplan

# Mostrar resumen del plan
echo ""
echo "📊 RESUMEN DEL PLAN:"
terraform show -json tfplan | jq -r '.resource_changes[] | select(.change.actions[] | contains("create")) | .address' | wc -l | xargs echo "• Recursos a crear:"
terraform show -json tfplan | jq -r '.resource_changes[] | select(.change.actions[] | contains("update")) | .address' | wc -l | xargs echo "• Recursos a actualizar:"
terraform show -json tfplan | jq -r '.resource_changes[] | select(.change.actions[] | contains("delete")) | .address' | wc -l | xargs echo "• Recursos a eliminar:"

# Confirmar deployment
echo ""
echo "🚨 ¿Proceder con el deployment? (y/N)"
read -r CONFIRM

if [[ $CONFIRM =~ ^[Yy]$ ]]; then
    echo "🚀 Desplegando infraestructura..."
    terraform apply tfplan
    
    # Limpiar plan file
    rm -f tfplan
    
    # Obtener outputs importantes
    echo ""
    echo "✅ ¡Deployment completado!"
    echo ""
    echo "📊 RECURSOS CREADOS:"
    terraform output
    
    # Configurar webhook en Telegram
    WEBHOOK_URL=$(terraform output -raw webhook_url 2>/dev/null || echo "")
    if [ -n "$WEBHOOK_URL" ] && [ -n "$TG_BOT_TOKEN" ]; then
        echo ""
        echo "🔗 Configurando webhook en Telegram..."
        
        RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot$TG_BOT_TOKEN/setWebhook" \
                        -H "Content-Type: application/json" \
                        -d "{\"url\":\"$WEBHOOK_URL\"}")
        
        if echo "$RESPONSE" | grep -q '"ok":true'; then
            echo "✅ Webhook configurado exitosamente"
        else
            echo "❌ Error configurando webhook:"
            echo "$RESPONSE"
        fi
    fi
    
    # Mostrar información de monitoreo
    echo ""
    echo "🎉 ¡Bot desplegado exitosamente!"
    echo ""
    echo "📍 INFORMACIÓN IMPORTANTE:"
    echo "• URL del webhook: $WEBHOOK_URL"
    echo "• Región AWS: $(terraform output -raw aws_region 2>/dev/null || echo 'us-east-1')"
    echo "• Proyecto: $PROJECT_NAME"
    echo "• Ambiente: $ENVIRONMENT"
    echo ""
    echo "📊 MONITOREO:"
    FUNCTION_NAME=$(terraform output -raw lambda_function_name 2>/dev/null || echo "")
    if [ -n "$FUNCTION_NAME" ]; then
        echo "• Logs: aws logs tail \"/aws/lambda/$FUNCTION_NAME\" --follow"
        echo "• Métricas: AWS Console > Lambda > $FUNCTION_NAME"
    fi
    echo "• DynamoDB: AWS Console > DynamoDB > Tables"
    echo "• S3: AWS Console > S3 > Buckets"
    echo ""
    echo "🔧 PRÓXIMOS PASOS:"
    echo "1. Desplegar código Lambda desde telegram-bot-lambda repo"
    echo "2. Probar el bot enviando /start"
    echo "3. Monitorear logs en CloudWatch"
    echo "4. Configurar alarmas (opcional)"
    
else
    echo "❌ Deployment cancelado"
    rm -f tfplan
    exit 1
fi
