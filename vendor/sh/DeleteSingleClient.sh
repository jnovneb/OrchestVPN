#!/bin/bash

# Verificar si el script se ejecuta con privilegios de superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse con privilegios de superusuario."
  exit 1
fi

# Verificar si se proporcionó el nombre del cliente a revocar
if [ $# -lt 1 ]; then
  echo "Uso: $0 <NOMBRE_DEL_CLIENTE>"
  exit 1
fi

# Asignar el nombre del cliente a revocar a una variable
CLIENT="$1"
ruta="$2"

# Verificar si el cliente existe
CLIENTEXISTS=$(tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep -c -E "/CN=$CLIENT\$")
if [[ $CLIENTEXISTS == '0' ]]; then
  echo ""
  echo "El cliente especificado no existe en easy-rsa."
  exit
fi

cd /etc/openvpn/easy-rsa/ || exit
./easyrsa --batch revoke "$CLIENT"
EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
rm -f /etc/openvpn/crl.pem
cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
chmod 644 /etc/openvpn/crl.pem
rm -r "/$ruta/$CLIENT"
sed -i "/^$CLIENT,.*/d" /etc/openvpn/ipp.txt
cp /etc/openvpn/easy-rsa/pki/index.txt{,.bk}

echo ""
echo "Certificado para el cliente $CLIENT revocado y la carpeta eliminada."
