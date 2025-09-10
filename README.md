# Bot Finance Infrastructure 🤖💰

Infraestructura como código para bot de finanzas personales en AWS usando Terraform con arquitectura modular.

## 🏗️ Arquitectura

```
Telegram Bot → API Gateway → Lambda Functions → DynamoDB
                                            ↓
                                      S3 (Finanzas)
```

## 📁 Estructura del Proyecto

```
bot-finance-terraform/
├── README.md
├── base/                           # Recursos base y código fuente
│   ├── lambda/
│   │   ├── bot-handler/           # Función principal del bot
│   │   ├── webhook-processor/     # Procesador de webhooks
│   │   └── layers/               # Capas de Lambda
│   └── api-gateway/
│       └── openapi-spec.yaml     # Especificación OpenAPI
├── environments/                  # Configuraciones por ambiente
│   └── prod/
│       ├── main.tf               # Configuración principal
│       ├── provider.tf           # Configuración del provider
│       ├── terraform.tfvars      # Variables del ambiente
│       └── variables.tf          # Definición de variables
└── modules/                      # Módulos reutilizables
    ├── api-gateway/             # Módulo API Gateway
    ├── cloudwatch/              # Módulo CloudWatch
    ├── dynamodb/                # Módulo DynamoDB
    ├── iam/                     # Módulo IAM
    ├── lambda/                  # Módulos Lambda
    │   ├── bot-handler/
    │   ├── webhook-processor/
    │   └── layers/
    ├── s3/                      # Módulo S3
    └── systems-manager/         # Módulo Systems Manager
```

## 🚀 Deployment

### Prerrequisitos
- AWS CLI configurado
- Terraform >= 1.0
- Token del bot de Telegram

### Instrucciones

1. **Clonar repositorio**
```bash
git clone <repo-terraform>
cd bot-finance-terraform
```

2. **Configurar variables**
```bash
cd environments/prod
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con tus valores
```

3. **Desplegar infraestructura**
```bash
terraform init
terraform plan
terraform apply
```

4. **Configurar webhook**
```bash
# El output mostrará la URL del webhook
terraform output webhook_url
```

## 🛠️ Módulos

### API Gateway
- Endpoint REST API
- Integración con Lambda
- Configuración CORS
- Rate limiting

### Lambda Functions
- **bot-handler**: Lógica principal del bot
- **webhook-processor**: Procesamiento de webhooks
- **layers**: Dependencias compartidas

### DynamoDB
- Tabla de transacciones
- Índices secundarios
- Configuración de capacidad

### S3
- Bucket para boletas
- Configuración de encriptación
- Políticas de acceso

### CloudWatch
- Log groups
- Métricas personalizadas
- Alarmas

### IAM
- Roles y políticas
- Principio de menor privilegio
- Permisos específicos por función

### Systems Manager
- Parámetros seguros
- Configuración de la aplicación

## 🔧 Configuración

### Variables Principales
- `project_name`: Nombre del proyecto
- `environment`: Ambiente (prod, dev, staging)
- `aws_region`: Región de AWS
- `telegram_token`: Token del bot (almacenado en SSM)

### Outputs
- `api_gateway_url`: URL del API Gateway
- `webhook_url`: URL completa del webhook
- `s3_bucket_name`: Nombre del bucket S3
- `dynamodb_table_name`: Nombre de la tabla DynamoDB

## 🔐 Seguridad

- Roles IAM con permisos mínimos
- Encriptación en tránsito y reposo
- Tokens almacenados en SSM Parameter Store
- VPC endpoints para servicios AWS (opcional)

## 💰 Costos (Free Tier)

Diseñado para mantenerse dentro del AWS Free Tier:
- Lambda: 1M requests/mes
- API Gateway: 1M requests/mes
- DynamoDB: 25GB storage
- S3: 5GB storage
- CloudWatch: 5GB logs/mes

## 🤝 Contribución

1. Fork el repositorio
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## 📝 Notas

- State remoto recomendado para producción
- Usar workspaces para múltiples ambientes
- Revisar costs antes de aplicar cambios
- Seguir convenciones de naming
