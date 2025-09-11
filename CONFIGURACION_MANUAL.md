# Configuración Manual Post-Despliegue

Una vez que el workflow de GitHub haya desplegado la infraestructura, necesitarás configurar manualmente algunos valores en la consola de AWS.

## 🔧 Configuraciones Requeridas

### 1. Token de Telegram Bot

El token se debe configurar en AWS Systems Manager Parameter Store:

**Ruta del parámetro:**
```
/finanzas-bot-finance-{ambiente}/telegram/token
```

**Pasos:**
1. Ve a AWS Console → Systems Manager → Parameter Store
2. Busca el parámetro con el nombre de arriba
3. Crea o actualiza el parámetro como `SecureString`
4. Ingresa tu token de bot de Telegram obtenido de @BotFather

### 2. Configuración del Webhook de Telegram (cuando API Gateway esté desplegado)

Una vez que tengas el API Gateway desplegado, configura el webhook:

```bash
curl -X POST "https://api.telegram.org/bot{TU_TOKEN}/setWebhook" \
     -H "Content-Type: application/json" \
     -d '{"url":"{URL_DEL_API_GATEWAY}"}'
```

### 3. Otros Parámetros (si es necesario)

Dependiendo de los módulos desplegados, podrías necesitar configurar:
- Configuraciones específicas de la aplicación
- Claves de API adicionales
- Configuraciones de base de datos

## 📝 Notas Importantes

- Los parámetros sensibles nunca se almacenan en el código fuente
- Usa GitHub Secrets solo para automatización, no para configuración de aplicaciones
- La infraestructura se despliega como "cascarones" que luego configuras manualmente
- El workflow mostrará las URLs y nombres de recursos creados para facilitar la configuración

## 🔍 Verificar Despliegue

Para verificar que todo esté funcionando:

1. Revisa los outputs del terraform
2. Verifica que los recursos existan en AWS Console
3. Prueba el bot enviando `/start` en Telegram (una vez configurado)
