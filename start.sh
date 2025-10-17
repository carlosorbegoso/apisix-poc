#!/bin/bash

echo "🚀 Configurando Apache APISIX 3.14..."

# Crear directorios necesarios
mkdir -p apisix_logs

# Limpiar contenedores anteriores
echo "🧹 Limpiando contenedores anteriores..."
docker-compose down -v > /dev/null 2>&1

# Iniciar etcd primero
echo "📡 Iniciando etcd..."
docker-compose up -d etcd

# Esperar a que etcd esté listo
echo "⏳ Esperando a que etcd esté listo..."
sleep 15

# Verificar que etcd esté funcionando
echo "🔍 Verificando etcd..."
if docker-compose exec -T etcd etcdctl endpoint health > /dev/null 2>&1; then
    echo "✅ etcd está funcionando correctamente"
else
    echo "❌ Error: etcd no está funcionando correctamente"
    echo "📋 Revisa los logs con: docker-compose logs etcd"
    exit 1
fi

# Crear configuración de APISIX
echo "⚙️  Creando configuración de APISIX..."
cat > apisix_conf/config.yaml << 'EOF'
apisix:
  node_listen: 9080
  enable_control: true
  control:
    ip: "0.0.0.0"
    port: 9092
  enable_admin: true
  enable_admin_cors: true
  admin_key:
    - name: "admin"
      key: edd1c9f034335f136f87ad84b625c8f1
      role: admin
  enable_debug: false
  enable_dev_mode: false
  enable_reuseport: true
  enable_ipv6: false
  config_center: etcd

etcd:
  host:
    - "http://etcd:2379"
  prefix: "/apisix"
  timeout: 30
EOF

# Iniciar APISIX
echo "🚀 Iniciando APISIX..."
docker-compose up -d apisix

# Esperar a que APISIX esté listo
echo "⏳ Esperando a que APISIX esté listo..."
sleep 30

# Verificar el estado de los servicios
echo "🔍 Verificando estado de los servicios..."
docker-compose ps

# Verificar que APISIX esté funcionando
echo "🧪 Probando APISIX..."
sleep 10

if curl -f http://localhost:9080/apisix/status > /dev/null 2>&1; then
    echo "✅ APISIX está funcionando correctamente!"
    echo ""
    echo "🌐 Servicios disponibles:"
    echo "   - APISIX HTTP: http://localhost:9080"
    echo "   - APISIX HTTPS: https://localhost:9443"
    echo "   - APISIX Admin API: http://localhost:9092"
    echo "   - Prometheus Metrics: http://localhost:9091"
    echo ""
    echo "🔑 Claves de administración:"
    echo "   - Admin Key: edd1c9f034335f136f87ad84b625c8f1"
    echo ""
    echo "📊 Para ver los logs: docker-compose logs -f"
    echo "🛑 Para detener: docker-compose down"
    echo ""
    echo "🧪 Prueba básica:"
    echo "   curl http://localhost:9080/apisix/status"
else
    echo "❌ Error: APISIX no está respondiendo correctamente"
    echo "📋 Revisa los logs con: docker-compose logs apisix"
    echo "📋 Estado de contenedores: docker-compose ps"
    exit 1
fi