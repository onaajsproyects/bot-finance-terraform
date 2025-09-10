#!/bin/bash

# Script para destruir la infraestructura
set -e

ENVIRONMENT=${1:-prod}

echo "🗑️ Destruyendo infraestructura del ambiente: $ENVIRONMENT"

# Verificar credenciales
if ! aws sts get-caller-identity >/dev/null 2>&1; then
    echo "❌ No hay credenciales de AWS configuradas"
    exit 1
fi

cd "environments/$ENVIRONMENT"

# Múltiples confirmaciones para evitar destrucción accidental
echo "⚠️  ADVERTENCIA: Esto eliminará TODA la infraestructura"
echo "🗑️ Ambiente a destruir: $ENVIRONMENT"
echo ""
echo "¿Estás seguro? (y/N)"
read -r CONFIRM1

if [[ ! $CONFIRM1 =~ ^[Yy]$ ]]; then
    echo "❌ Operación cancelada"
    exit 0
fi

echo ""
echo "🚨 ÚLTIMA CONFIRMACIÓN"
echo "Esta acción NO se puede deshacer"
echo "Escribe 'DESTROY' para continuar:"
read -r FINAL_CONFIRM

if [ "$FINAL_CONFIRM" != "DESTROY" ]; then
    echo "❌ Confirmación incorrecta. Operación cancelada."
    exit 0
fi

echo ""
echo "🗑️ Destruyendo infraestructura..."

# Generar plan de destrucción
terraform plan -destroy -out=destroy-plan

# Aplicar destrucción
terraform apply destroy-plan

# Limpiar archivos
rm -f destroy-plan
rm -f terraform.tfstate.backup

echo ""
echo "✅ Infraestructura destruida completamente"
echo ""
echo "🧹 LIMPIEZA MANUAL REQUERIDA:"
echo "• Revisar S3 buckets para archivos residuales"
echo "• Verificar logs de CloudWatch"
echo "• Revisar parámetros de SSM"
echo ""
echo "💡 Para restaurar, ejecuta ./scripts/deploy.sh $ENVIRONMENT"
