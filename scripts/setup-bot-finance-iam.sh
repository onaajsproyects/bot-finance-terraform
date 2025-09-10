#!/bin/bash

# Script para crear usuario IAM bot-finance con políticas por servicio
# Principio de menor privilegio - una política por servicio AWS

set -e

PROFILE=${1:-personal}
SPECIFIC_SERVICE=${2:-""}
USER_NAME="bot-finance"
PROJECT_PREFIX="bot-finance"
POLICIES_DIR="$(dirname "$0")/bot-finance-policies"

echo "🔐 Configurando usuario IAM para proyecto Bot Finance"
echo "👤 Usuario: $USER_NAME"
echo "🏷️ Perfil AWS: $PROFILE"

if [[ -n "$SPECIFIC_SERVICE" ]]; then
    echo "🎯 Servicio específico: $SPECIFIC_SERVICE"
else
    echo "📦 Todos los servicios"
fi
echo ""

# Verificar que existe el directorio de políticas
if [[ ! -d "$POLICIES_DIR" ]]; then
    echo "❌ Error: No se encuentra el directorio de políticas: $POLICIES_DIR"
    exit 1
fi

# Definir servicios disponibles
declare -a AVAILABLE_SERVICES=(
    "lambda"
    "dynamodb" 
    "s3"
    "apigateway"
    "ssm"
    "iam"
    "cloudwatch"
)

# Función para mostrar ayuda
show_help() {
    echo "📖 USO:"
    echo "  $0 [perfil-aws] [servicio-específico]"
    echo ""
    echo "📋 PARÁMETROS:"
    echo "  perfil-aws          Perfil AWS a usar (default: personal)"
    echo "  servicio-específico Servicio específico a actualizar (opcional)"
    echo ""
    echo "🔧 SERVICIOS DISPONIBLES:"
    for service in "${AVAILABLE_SERVICES[@]}"; do
        echo "  • $service"
    done
    echo ""
    echo "💡 EJEMPLOS:"
    echo "  $0                    # Configurar todos los servicios con perfil 'personal'"
    echo "  $0 personal           # Configurar todos los servicios con perfil 'personal'"
    echo "  $0 personal lambda    # Actualizar solo la política de Lambda"
    echo "  $0 prod s3            # Actualizar solo la política de S3 con perfil 'prod'"
}

# Verificar si se pide ayuda
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
    exit 0
fi

# Validar servicio específico si se proporciona
if [[ -n "$SPECIFIC_SERVICE" ]]; then
    if [[ ! " ${AVAILABLE_SERVICES[*]} " =~ " ${SPECIFIC_SERVICE} " ]]; then
        echo "❌ Error: Servicio '$SPECIFIC_SERVICE' no reconocido"
        echo ""
        show_help
        exit 1
    fi
fi

# Verificar credenciales
echo "🔍 Verificando credenciales AWS..."
if ! aws sts get-caller-identity --profile $PROFILE >/dev/null 2>&1; then
    echo "❌ Error: No se pudo verificar credenciales para perfil '$PROFILE'"
    echo "Ejecuta: aws configure --profile $PROFILE"
    exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --profile $PROFILE --query Account --output text)
echo "✅ Conectado a cuenta: $ACCOUNT_ID"
echo ""

# Verificar que jq está instalado para validar JSON
if ! command -v jq &> /dev/null; then
    echo "❌ Error: 'jq' no está instalado. Se necesita para validar archivos JSON."
    echo "Instalar con: brew install jq"
    exit 1
fi

# Función para crear o actualizar política desde archivo JSON
create_or_update_policy_from_file() {
    local service_name=$1
    local policy_file="$POLICIES_DIR/${service_name}-policy.json"
    local policy_name="${PROJECT_PREFIX}-${service_name}-policy"
    local description="Permisos ${service_name} para proyecto Bot Finance"
    
    if [[ ! -f "$policy_file" ]]; then
        echo "❌ Error: No se encuentra el archivo de política: $policy_file"
        return 1
    fi
    
    echo "📋 Procesando política: $policy_name"
    echo "📄 Archivo: $policy_file"
    
    # Validar JSON
    if ! jq empty "$policy_file" >/dev/null 2>&1; then
        echo "❌ Error: El archivo $policy_file no contiene JSON válido"
        return 1
    fi
    
    local policy_document=$(cat "$policy_file")
    
    # Verificar si la política existe
    if aws iam get-policy --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/$policy_name" --profile $PROFILE >/dev/null 2>&1; then
        echo "🔄 Actualizando política existente: $policy_name"
        
        # Crear nueva versión de la política
        aws iam create-policy-version \
            --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/$policy_name" \
            --policy-document "$policy_document" \
            --set-as-default \
            --profile $PROFILE
            
        echo "✅ Política actualizada: $policy_name"
    else
        echo "📝 Creando nueva política: $policy_name"
        
        # Crear nueva política
        aws iam create-policy \
            --policy-name "$policy_name" \
            --policy-document "$policy_document" \
            --description "$description" \
            --profile $PROFILE
            
        echo "✅ Política creada: $policy_name"
    fi
}

# Procesar servicios
if [[ -n "$SPECIFIC_SERVICE" ]]; then
    echo "🎯 Procesando servicio específico: $SPECIFIC_SERVICE"
    echo ""
    
    case $SPECIFIC_SERVICE in
        "lambda")
            echo "🚀 Configurando políticas para Lambda..."
            create_or_update_policy_from_file "lambda"
            services_to_attach=("lambda")
            ;;
        "dynamodb")
            echo "🗄️ Configurando políticas para DynamoDB..."
            create_or_update_policy_from_file "dynamodb"
            services_to_attach=("dynamodb")
            ;;
        "s3")
            echo "🪣 Configurando políticas para S3..."
            create_or_update_policy_from_file "s3"
            services_to_attach=("s3")
            ;;
        "apigateway")
            echo "🌐 Configurando políticas para API Gateway..."
            create_or_update_policy_from_file "apigateway"
            services_to_attach=("apigateway")
            ;;
        "ssm")
            echo "🔧 Configurando políticas para Systems Manager..."
            create_or_update_policy_from_file "ssm"
            services_to_attach=("ssm")
            ;;
        "iam")
            echo "🔐 Configurando políticas para IAM..."
            create_or_update_policy_from_file "iam"
            services_to_attach=("iam")
            ;;
        "cloudwatch")
            echo "📊 Configurando políticas para CloudWatch..."
            create_or_update_policy_from_file "cloudwatch"
            services_to_attach=("cloudwatch")
            ;;
    esac
else
    echo "📦 Procesando todos los servicios..."
    echo ""
    
    # Configurar todas las políticas
    echo "🚀 Configurando políticas para Lambda..."
    create_or_update_policy_from_file "lambda"

    echo "🗄️ Configurando políticas para DynamoDB..."
    create_or_update_policy_from_file "dynamodb"

    echo "🪣 Configurando políticas para S3..."
    create_or_update_policy_from_file "s3"

    echo "🌐 Configurando políticas para API Gateway..."
    create_or_update_policy_from_file "apigateway"

    echo "🔧 Configurando políticas para Systems Manager..."
    create_or_update_policy_from_file "ssm"

    echo "🔐 Configurando políticas para IAM..."
    create_or_update_policy_from_file "iam"

    echo "📊 Configurando políticas para CloudWatch..."
    create_or_update_policy_from_file "cloudwatch"
    
    services_to_attach=("lambda" "dynamodb" "s3" "apigateway" "ssm" "iam" "cloudwatch")
fi

# Crear o actualizar usuario
echo ""
echo "👤 Configurando usuario IAM..."
if aws iam get-user --user-name $USER_NAME --profile $PROFILE >/dev/null 2>&1; then
    echo "✅ Usuario '$USER_NAME' ya existe"
else
    echo "📝 Creando usuario '$USER_NAME'"
    aws iam create-user \
        --user-name $USER_NAME \
        --profile $PROFILE
    echo "✅ Usuario '$USER_NAME' creado"
fi

# Adjuntar políticas al usuario
echo ""
echo "🔗 Adjuntando políticas al usuario..."

for service in "${services_to_attach[@]}"; do
    policy_name="${PROJECT_PREFIX}-${service}-policy"
    echo "🔗 Adjuntando política: $policy_name"
    aws iam attach-user-policy \
        --user-name $USER_NAME \
        --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/$policy_name" \
        --profile $PROFILE
    echo "✅ Política adjuntada: $policy_name"
done

echo ""
echo "🎉 ¡Configuración IAM completada!"
echo ""
echo "📊 RESUMEN:"
echo "• Usuario: $USER_NAME"
echo "• Políticas procesadas: ${#services_to_attach[@]}"
echo "• Principio de menor privilegio aplicado"
echo "• Recursos limitados al prefijo 'bot-finance-*'"
echo ""
echo "🔑 SIGUIENTES PASOS:"
echo "1. Crear Access Keys para el usuario:"
echo "   aws iam create-access-key --user-name $USER_NAME --profile $PROFILE"
echo ""
echo "2. Configurar perfil con las nuevas credenciales:"
echo "   aws configure --profile bot-finance"
echo ""
echo "3. Verificar permisos:"
echo "   aws sts get-caller-identity --profile bot-finance"
