# Bot Finance - Políticas IAM

Este directorio contiene las políticas IAM específicas por servicio para el proyecto Bot Finance, siguiendo el principio de menor privilegio.

## 📁 Estructura

```
bot-finance-policies/
├── README.md
├── lambda-policy.json          # Permisos para AWS Lambda
├── dynamodb-policy.json        # Permisos para DynamoDB
├── s3-policy.json              # Permisos para S3
├── apigateway-policy.json      # Permisos para API Gateway
├── ssm-policy.json             # Permisos para Systems Manager
├── iam-policy.json             # Permisos mínimos para IAM
└── cloudwatch-policy.json      # Permisos para CloudWatch Logs
```

## 🎯 Principio de Menor Privilegio

Cada política está diseñada para otorgar solo los permisos mínimos necesarios para:
- **Recursos específicos**: Solo recursos con prefijo `bot-finance-*`
- **Acciones específicas**: Solo las operaciones necesarias para cada servicio
- **Alcance limitado**: Restricciones por región y tipo de recurso cuando sea posible

## 🔧 Uso del Script

### Configurar todos los servicios
```bash
./setup-bot-finance-iam.sh personal
```

### Actualizar un servicio específico
```bash
./setup-bot-finance-iam.sh personal lambda      # Solo Lambda
./setup-bot-finance-iam.sh personal dynamodb    # Solo DynamoDB
./setup-bot-finance-iam.sh personal s3          # Solo S3
```

### Ver ayuda
```bash
./setup-bot-finance-iam.sh --help
```

## 📝 Editar Políticas

Para modificar los permisos de un servicio:

1. **Edita el archivo JSON correspondiente** (ej: `lambda-policy.json`)
2. **Valida el JSON** con `jq`:
   ```bash
   jq empty lambda-policy.json
   ```
3. **Ejecuta el script** para actualizar:
   ```bash
   ./setup-bot-finance-iam.sh personal lambda
   ```

## 🔒 Políticas Incluidas

### Lambda (`lambda-policy.json`)
- Crear, actualizar, eliminar funciones Lambda
- Gestionar permisos y configuración
- Event source mappings
- **Limitado a**: `bot-finance-*` functions

### DynamoDB (`dynamodb-policy.json`)
- Operaciones CRUD en tablas
- Crear/eliminar tablas
- Gestionar índices y TTL
- **Limitado a**: `bot-finance-*` tables

### S3 (`s3-policy.json`)
- Gestión de buckets y objetos
- Configuración de políticas y encriptación
- Versionado y bloqueo de acceso público
- **Limitado a**: `bot-finance-*` buckets

### API Gateway (`apigateway-policy.json`)
- Crear y gestionar REST APIs
- Configurar deployments y stages
- Planes de uso y throttling
- **Limitado a**: APIs del proyecto

### Systems Manager (`ssm-policy.json`)
- Gestionar parámetros de configuración
- Parámetros seguros (SecureString)
- **Limitado a**: `/bot-finance/*` parameters

### IAM (`iam-policy.json`)
- Crear roles para Lambda
- Gestionar políticas del proyecto
- **Limitado a**: `bot-finance-*` roles y policies

### CloudWatch (`cloudwatch-policy.json`)
- Crear y gestionar log groups
- Escribir logs desde Lambda
- **Limitado a**: `/aws/lambda/bot-finance-*` log groups

## 🚨 Seguridad

- **Nunca** edites las políticas para incluir `"Resource": "*"` sin justificación
- **Siempre** mantén el prefijo `bot-finance-*` en los recursos
- **Revisa** regularmente los permisos para eliminar los que no se usen
- **Usa** servicios específicos en lugar de actualizar todas las políticas

## 📊 Validación

Para verificar que las políticas están correctamente formateadas:

```bash
# Validar todas las políticas
for file in *.json; do
  echo "Validating $file..."
  jq empty "$file" && echo "✅ $file es válido" || echo "❌ $file tiene errores"
done
```

## 🔄 Versionado

AWS IAM mantiene hasta 5 versiones de cada política. Al usar el script:
- Se crea una nueva versión si la política existe
- Se establece como versión por defecto automáticamente
- Las versiones anteriores se conservan para rollback si es necesario
