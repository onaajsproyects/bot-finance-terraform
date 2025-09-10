#!/bin/bash

# Script para obtener las credenciales AWS del perfil bot-finance
# Úsalo para copiar-pegar en GitHub Secrets

echo "==================================="
echo "🔐 CREDENCIALES PARA GITHUB SECRETS"
echo "==================================="
echo ""
echo "📝 Copia estos valores en GitHub:"
echo ""
echo "Secreto: AWS_ACCESS_KEY_ID"
echo "Valor:"
aws configure get aws_access_key_id --profile bot-finance
echo ""
echo "Secreto: AWS_SECRET_ACCESS_KEY"
echo "Valor:"
aws configure get aws_secret_access_key --profile bot-finance
echo ""
echo "==================================="
echo "⚠️  IMPORTANTE:"
echo "- NUNCA commitees estas credenciales"
echo "- Úsalas solo para GitHub Secrets"
echo "- Elimina este output después de usarlo"
echo "==================================="
