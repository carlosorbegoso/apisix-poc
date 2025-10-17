# Apache APISIX 3.14 - Docker Compose Setup

Esta configuración incluye Apache APISIX 3.14 con todas las dependencias necesarias usando Docker Compose.

## 🚀 Inicio Rápido

### Prerrequisitos
- Docker
- Docker Compose
- OpenSSL (para generar certificados SSL)

### Instalación y Configuración

1. **Iniciar APISIX:**
   ```bash
   ./start.sh
   ```

2. **Configurar ejemplo de API Gateway (opcional):**
   ```bash
   ./setup-example.sh
   ```

## 📋 Servicios Incluidos

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| **APISIX** | 9080 (HTTP), 9443 (HTTPS) | Gateway principal |
| **APISIX Admin API** | 9092 | API de administración |
| **APISIX Dashboard** | 9000 | Interfaz web de administración |
| **Prometheus Metrics** | 9091 | Métricas de monitoreo |
| **etcd** | 2379 | Base de datos de configuración |

## 🔑 Claves de Administración

- **Admin Key:** `edd1c9f034335f136f87ad84b625c8f1`
- **Viewer Key:** `4054f7cf07e344346cd3f287985e76a2`

## 🌐 Accesos

- **APISIX HTTP:** http://localhost:9080
- **APISIX HTTPS:** https://localhost:9443
- **Dashboard:** http://localhost:9000
- **Admin API:** http://localhost:9092
- **Métricas:** http://localhost:9091

## 🧪 Ejemplos de Uso

### Crear una Ruta Simple
```bash
curl -X PUT http://localhost:9092/apisix/admin/routes/1 \
  -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" \
  -H "Content-Type: application/json" \
  -d '{
    "uri": "/hello",
    "methods": ["GET"],
    "upstream": {
      "type": "roundrobin",
      "nodes": {
        "httpbin.org:80": 1
      }
    }
  }'
```

### Probar la Ruta
```bash
curl http://localhost:9080/hello
```

### Crear un Upstream
```bash
curl -X PUT http://localhost:9092/apisix/admin/upstreams/1 \
  -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "roundrobin",
    "nodes": {
      "httpbin.org:80": 1
    }
  }'
```

### Crear un Consumer con Autenticación
```bash
curl -X PUT http://localhost:9092/apisix/admin/consumers/test-user \
  -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "test-user",
    "plugins": {
      "key-auth": {
        "key": "test-key-123"
      }
    }
  }'
```

## 🔧 Comandos Útiles

### Gestión de Servicios
```bash
# Iniciar servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f apisix

# Detener servicios
docker-compose down

# Reiniciar servicios
docker-compose restart

# Ver estado de servicios
docker-compose ps
```

### Verificar Estado
```bash
# Verificar que APISIX esté funcionando
curl http://localhost:9080/apisix/status

# Ver todas las rutas
curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" \
  http://localhost:9092/apisix/admin/routes

# Ver todos los upstreams
curl -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" \
  http://localhost:9092/apisix/admin/upstreams
```

## 📁 Estructura de Archivos

```
.
├── docker-compose.yml          # Configuración principal de Docker Compose
├── start.sh                   # Script de inicio automático
├── setup-example.sh           # Script de configuración de ejemplo
├── apisix_conf/
│   └── config.yaml           # Configuración de APISIX
├── dashboard_conf/
│   └── conf.yaml             # Configuración del Dashboard
├── apisix_logs/              # Logs de APISIX
└── cert/                     # Certificados SSL
```

## 🔌 Plugins Disponibles

APISIX incluye más de 80 plugins preinstalados, incluyendo:

- **Autenticación:** key-auth, basic-auth, jwt-auth, hmac-auth
- **Seguridad:** cors, csrf, ip-restriction, ua-restriction
- **Rate Limiting:** limit-req, limit-count, limit-conn
- **Logging:** http-logger, tcp-logger, kafka-logger, elasticsearch-logger
- **Monitoreo:** prometheus, datadog, zipkin
- **Transformación:** response-rewrite, request-validation
- **Load Balancing:** roundrobin, consistent-hash, least-conn

## 🛠️ Personalización

### Modificar Configuración de APISIX
Edita el archivo `apisix_conf/config.yaml` y reinicia el servicio:
```bash
docker-compose restart apisix
```

### Modificar Configuración del Dashboard
Edita el archivo `dashboard_conf/conf.yaml` y reinicia el servicio:
```bash
docker-compose restart apisix-dashboard
```

### Agregar Plugins Personalizados
1. Crea tu plugin en el directorio `apisix_conf/plugins/`
2. Modifica `config.yaml` para incluir el plugin
3. Reinicia APISIX

## 🐛 Solución de Problemas

### APISIX no responde
```bash
# Verificar logs
docker-compose logs apisix

# Verificar estado de etcd
docker-compose logs etcd

# Verificar conectividad
curl http://localhost:9080/apisix/status
```

### Dashboard no carga
```bash
# Verificar logs del dashboard
docker-compose logs apisix-dashboard

# Verificar conectividad con APISIX
curl http://localhost:9092/apisix/admin/routes
```

### Problemas de SSL
```bash
# Regenerar certificados
rm cert/apisix.*
./start.sh
```

## 📚 Recursos Adicionales

- [Documentación oficial de APISIX](https://apisix.apache.org/docs/)
- [API Reference](https://apisix.apache.org/docs/apisix/admin-api/)
- [Plugin Development](https://apisix.apache.org/docs/apisix/plugin-development/)
- [Docker Hub - APISIX](https://hub.docker.com/r/apache/apisix)

## 🤝 Contribuir

Si encuentras algún problema o tienes sugerencias, por favor:
1. Revisa los logs: `docker-compose logs`
2. Verifica la configuración
3. Consulta la documentación oficial
4. Crea un issue con detalles del problema

---

**¡Disfruta usando Apache APISIX! 🎉**
# apisix-poc
