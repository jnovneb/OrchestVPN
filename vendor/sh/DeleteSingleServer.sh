#!/bin/bash

# Verificar si el script se ejecuta con privilegios de superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse con privilegios de superusuario."
  exit 1
fi

# Verificar si se proporcionó el nombre del servidor como argumento
if [ $# -lt 1 ]; then
  echo "Uso: $0 <NOMBRE_DEL_SERVIDOR>"
  exit 1
fi

# Obtener el nombre del servidor
SERVIDOR="$1"

# Detener y deshabilitar el servicio OpenVPN del servidor
systemctl stop openvpn@${SERVIDOR}
systemctl disable openvpn@${SERVIDOR}

# Eliminar los archivos de configuración y certificados del servidor
rm -rf /etc/openvpn/${SERVIDOR}

echo "El servidor de OpenVPN \"$SERVIDOR\" ha sido eliminado correctamente."

