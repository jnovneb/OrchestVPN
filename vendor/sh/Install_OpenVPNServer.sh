#!/bin/bash

# Verificar si el script se ejecuta con privilegios de superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse con privilegios de superusuario."
  exit 1
fi

# Verificar si se proporcionó el número de puerto y el nombre de la carpeta
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Por favor, proporciona el número de puerto y el nombre de la carpeta como argumentos."
  exit 1
fi

# Asignar el número de puerto y el nombre de la carpeta a variables
PUERTO="$1"
CARPETA="$2"

# Crear la carpeta de configuración
mkdir "$CARPETA"
#Para poder tener distintos puertos se guarda en directorios separados por cada instancia de servidor
CONFIG_DIR="/etc/openvpn/$CARPETA"

# Actualizar el sistema
apt update && apt upgrade -y

# Instalar OpenVPN
apt install openvpn -y

# Configurar el servidor OpenVPN
cp -r /usr/share/doc/openvpn/examples/easy-rsa/ "$CONFIG_DIR"
cd "$CONFIG_DIR/easy-rsa/3.0/"

# Limpiar y generar los certificados
./easyrsa init-pki
./easyrsa --batch build-ca nopass
./easyrsa gen-crl
./easyrsa gen-dh

# Crear el archivo de configuración del servidor
echo "port $PUERTO" > "$CONFIG_DIR/server.conf"
echo "proto udp" >> "$CONFIG_DIR/server.conf"
echo "dev tun" >> "$CONFIG_DIR/server.conf"
echo "ca $CONFIG_DIR/easy-rsa/3.0/pki/ca.crt" >> "$CONFIG_DIR/server.conf"
echo "cert $CONFIG_DIR/easy-rsa/3.0/pki/issued/server.crt" >> "$CONFIG_DIR/server.conf"
echo "key $CONFIG_DIR/easy-rsa/3.0/pki/private/server.key" >> "$CONFIG_DIR/server.conf"
echo "dh $CONFIG_DIR/easy-rsa/3.0/pki/dh.pem" >> "$CONFIG_DIR/server.conf"
echo "crl-verify $CONFIG_DIR/easy-rsa/3.0/pki/crl.pem" >> "$CONFIG_DIR/server.conf"
echo "user nobody" >> "$CONFIG_DIR/server.conf"
echo "group nogroup" >> "$CONFIG_DIR/server.conf"
echo "persist-key" >> "$CONFIG_DIR/server.conf"
echo "persist-tun" >> "$CONFIG_DIR/server.conf"
echo "keepalive 10 120" >> "$CONFIG_DIR/server.conf"
echo "comp-lzo" >> "$CONFIG_DIR/server.conf"
echo "max-clients 20" >> "$CONFIG_DIR/server.conf"
echo "push \"redirect-gateway def1 bypass-dhcp\"" >> "$CONFIG_DIR/server.conf"
echo "push \"dhcp-option DNS 8.8.8.8\"" >> "$CONFIG_DIR/server.conf"
echo "push \"dhcp-option DNS 8.8.4.4\"" >> "$CONFIG_DIR/server.conf"
echo "user nobody" >> "$CONFIG_DIR/server.conf"
echo "group nogroup" >> "$CONFIG_DIR/server.conf"
echo "log-append $CONFIG_DIR/openvpn.log" >> "$CONFIG_DIR/server.conf"
echo "verb 3" >> "$CONFIG_DIR/server.conf"

# Habilitar el enrutamiento IP
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sys

#Reinicia servidor
systemctl restart $CARPETA

