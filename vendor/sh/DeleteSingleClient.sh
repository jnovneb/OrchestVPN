#!/bin/bash

# Verificar si el script se ejecuta con privilegios de superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse con privilegios de superusuario."
  exit 1
fi

# Verificar si se proporcionó el nombre del cliente como argumento
if [ $# -lt 1 ]; then
  echo "Uso: $0 <NOMBRE_DEL_CLIENTE>"
  exit 1
fi

# Obtener el nombre del cliente
CLIENTE="$1"

# Verificar si el cliente existe
if [ ! -d "/etc/openvpn/clientes/$CLIENTE" ]; then
  echo "El cliente OpenVPN \"$CLIENTE\" no existe."
  exit 1
fi

# Eliminar el archivo .ovpn del cliente
rm -f "/etc/openvpn/clientes/$CLIENTE/$CLIENTE.ovpn"

# Eliminar la carpeta del cliente
rm -rf "/etc/openvpn/clientes/$CLIENTE"

echo "El cliente OpenVPN \"$CLIENTE\" y el archivo .ovpn han sido eliminados correctamente."

