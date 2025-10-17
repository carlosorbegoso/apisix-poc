#!/bin/bash

# Script para crear un ejemplo de API Gateway con APISIX
echo "🔧 Configurando ejemplo de API Gateway..."

# Esperar a que APISIX esté listo
echo "⏳ Esperando a que APISIX esté listo..."
sleep 15

# Verificar que APISIX esté funcionando
if ! curl -f http://localhost:9080/apisix/status > /dev/null 2>&1; then
    echo "❌ APISIX no está funcionando. Ejecuta primero ./start.sh"
    exit 1
fi

# Crear un upstream de ejemplo (httpbin.org)
echo "📡 Creando upstream de ejemplo..."
curl -X PUT http://localhost:9092/apisix/admin/upstreams/1 \
  -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "roundrobin",
    "nodes": {
      "httpbin.org:80": 1
    }
  }'

# Crear una ruta de ejemplo
echo "🛣️  Creando ruta de ejemplo..."
curl -X PUT http://localhost:9092/apisix/admin/routes/1 \
  -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" \
  -H "Content-Type: application/json" \
  -d '{
    "uri": "/get",
    "methods": ["GET"],
    "upstream_id": 1,
    "plugins": {
      "cors": {
        "allow_origins": "*",
        "allow_methods": "*",
        "allow_headers": "*"
      }
    }
  }'

# Crear una ruta con autenticación
echo "🔐 Creando ruta con autenticación..."
curl -X PUT http://localhost:9092/apisix/admin/routes/2 \
  -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" \
  -H "Content-Type: application/json" \
  -d '{
    "uri": "/protected/*",
    "methods": ["GET", "POST"],
    "upstream_id": 1,
    "plugins": {
      "key-auth": {},
      "cors": {
        "allow_origins": "*",
        "allow_methods": "*",
        "allow_headers": "*"
      }
    }
  }'

# Crear un consumer para la autenticación
echo "👤 Creando consumer de ejemplo..."
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

echo ""
echo "✅ Configuración de ejemplo completada!"
echo ""
echo "🧪 Pruebas disponibles:"
echo "   - Ruta pública: curl http://localhost:9080/get"
echo "   - Ruta protegida: curl -H 'apikey: test-key-123' http://localhost:9080/protected/get"
echo ""
echo "📊 Ver configuración:"
echo "   - Rutas: curl -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' http://localhost:9092/apisix/admin/routes"
echo "   - Upstreams: curl -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' http://localhost:9092/apisix/admin/upstreams"
echo "   - Consumers: curl -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' http://localhost:9092/apisix/admin/consumers"
