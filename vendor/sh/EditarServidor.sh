#!/bin/bash

# Verificar si el script se ejecuta con privilegios de superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse con privilegios de superusuario."
  exit 1
fi

# Verificar si se proporcionó el nombre del servidor y los cambios como argumentos
if [ $# -lt 2 ]; then
  echo "Uso: $0 <NOMBRE_DEL_SERVIDOR> <CAMBIOS>"
  exit 1
fi

# Obtener el nombre del servidor y los cambios
SERVIDOR="$1"
CAMBIOS="$2"

# Verificar si el servidor existe
if [ ! -d "/etc/openvpn/$SERVIDOR" ]; then
  echo "El servidor OpenVPN \"$SERVIDOR\" no existe."
  exit 1
fi

# Obtener la ruta completa del archivo de configuración del servidor
ARCHIVO_CONFIG="/etc/openvpn/$SERVIDOR/server.conf"

# Realizar los cambios en el archivo de configuración
sed -i -e "$CAMBIOS" "$ARCHIVO_CONFIG"

echo "Los cambios han sido aplicados correctamente en la configuración del servidor \"$SERVIDOR\"."

