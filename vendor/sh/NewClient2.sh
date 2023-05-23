#!/bin/bash

# Verificar si el script se ejecuta con privilegios de superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse con privilegios de superusuario."
  exit 1
fi

# Verificar si se proporcionaron suficientes argumentos
if [ $# -lt 3 ]; then
  echo "Uso: $0 <IP_DEL_SERVIDOR> <PUERTO_DEL_SERVIDOR> <CLIENTE> [ANCHO_DE_BANDA] [CONTRASENA]"
  exit 1
fi

# Asignar argumentos a variables
IP_SERVIDOR=$1
PUERTO_SERVIDOR=$2
CLIENTE=$3
ANCHO_DE_BANDA=$4
CONTRASENA=$5

# Configurar la ruta de la carpeta de salida del cliente
OUTPUT_DIR="/etc/openvpn/clientes/$CLIENTE"

# Crear la carpeta de salida del cliente
mkdir -p "$OUTPUT_DIR"

# Copiar los archivos de configuración y certificados del servidor al cliente
cp /etc/openvpn/easy-rsa/3.0/pki/ca.crt "$OUTPUT_DIR"
cp /etc/openvpn/easy-rsa/3.0/pki/issued/$CLIENTE.crt "$OUTPUT_DIR"
cp /etc/openvpn/easy-rsa/3.0/pki/private/$CLIENTE.key "$OUTPUT_DIR"
cp /etc/openvpn/easy-rsa/3.0/pki/dh.pem "$OUTPUT_DIR"
cp /etc/openvpn/server.conf "$OUTPUT_DIR/client.ovpn"

# Añadir las configuraciones necesarias al archivo de configuración del cliente
echo "client" >> "$OUTPUT_DIR/client.ovpn"
echo "dev tun" >> "$OUTPUT_DIR/client.ovpn"
echo "proto udp" >> "$OUTPUT_DIR/client.ovpn"
echo "remote $IP_SERVIDOR $PUERTO_SERVIDOR" >> "$OUTPUT_DIR/client.ovpn"
echo "resolv-retry infinite" >> "$OUTPUT_DIR/client.ovpn"
echo "nobind" >> "$OUTPUT_DIR/client.ovpn"
echo "persist-key" >> "$OUTPUT_DIR/client.ovpn"
echo "persist-tun" >> "$OUTPUT_DIR/client.ovpn"
echo "remote-cert-tls server" >> "$OUTPUT_DIR/client.ovpn"
echo "comp-lzo" >> "$OUTPUT_DIR/client.ovpn"
echo "verb 3" >> "$OUTPUT_DIR/client.ovpn"

# Solicitar los usuarios del cliente separados por comas
#read -p "Usuarios del cliente (separados por comas): " USUARIOS

# Crear el archivo de autenticación del cliente
#echo -n "$USUARIOS" | tr -s ',' '\n' > "$OUTPUT_DIR/users.txt"

# Si se proporcionó una contraseña, crear el archivo de contraseña del cliente
if [ -n "$CONTRASENA" ]; then
  echo "$CONTRASENA" > "$OUTPUT_DIR/pass.txt"
fi

# Si se proporcionó un ancho de banda, limitarlo en el archivo de configuración del cliente
if [ -n "$ANCHO_DE_BANDA" ]; then
  echo "up /etc/openvpn/scripts/limit_bandwidth.sh $ANCHO_DE_BANDA" >> "$OUTPUT_DIR/client.ovpn"
fi

