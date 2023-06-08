#!/bin/bash

# Verificar si el script se ejecuta con privilegios de superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse con privilegios de superusuario."
  exit 1
fi

# Verificar si se proporcionaron suficientes argumentos
if [ $# -lt 4 ]; then
  echo "Uso: $0 <ruta> <NOMBRE_DEL_CLIENTE> <IP_DEL_SERVIDOR> <PUERTO_DEL_SERVIDOR> [CONTRASENA] [ANCHO_DE_BANDA]"
  exit 1
fi

# Asignar argumentos a variables
RUTA="$1"
CLIENT="$2"
PUERTO_SERVIDOR="$3"
CIDR="$4"

# Crear la carpeta del cliente con los permisos adecuados
clientDirec="$RUTA/$CLIENT"
mkdir -p "$clientDirec"
chmod 755 "$clientDirec"
chown "$SUDO_USER:$SUDO_USER" "$clientDirec"

cp /etc/openvpn/server.conf "$clientDirec/$CLIENT.conf"
sed "s/server [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+ 255.255.255.0/server $CIDR 255.255.255.0/" "$clientDirec/$CLIENT.conf"
sed -i "s/port [0-9]\+/port $PUERTO_SERVIDOR/" "$clientDirec/$CLIENT.conf"


echo "VPN $CLIENT añadida."


