#!/bin/bash

set -e

echo "🎉 Verificando Apache APISIX 3.14..."

# Verificar estado de servicios
echo ""
echo "📊 Estado de los servicios:"
podman-compose ps

# Verificar API Admin
echo ""
echo "🔍 Verificando API Admin..."
curl -s http://localhost:9180/apisix/admin/routes -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' | jq .

# Crear una ruta de ejemplo
echo ""
echo "📝 Creando ruta de ejemplo..."
curl -s http://localhost:9180/apisix/admin/routes/1 -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '{
  "uri": "/get",
  "methods": ["GET"],
  "upstream": {
    "type": "roundrobin",
    "nodes": {
      "httpbin.org:80": 1
    }
  }
}' | jq .

# Listar rutas
echo ""
echo "📋 Rutas configuradas:"
curl -s http://localhost:9180/apisix/admin/routes -H 'X-API-KEY: edd1c9f034335f136f87ad84b625c8f1' | jq .

# Probar la ruta
echo ""
echo "🧪 Probando la ruta /get..."
curl -s http://localhost:9080/get | jq . | head -20

echo ""
echo "✅ ¡Apache APISIX 3.14 está funcionando correctamente!"
echo ""
echo "🌐 Servicios disponibles:"
echo "   - APISIX Gateway: http://localhost:9080"
echo "   - Admin API: http://localhost:9180"
echo "   - Control API: http://localhost:9092"
echo "   - Prometheus Metrics: http://localhost:9091/apisix/prometheus/metrics"
echo "   - etcd: http://localhost:2379"
echo ""
echo "🔑 Admin API Key: edd1c9f034335f136f87ad84b625c8f1"
echo ""
echo "Para detener: podman-compose down"

