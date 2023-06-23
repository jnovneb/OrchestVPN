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
RUTA="$2"

rm -rf ${RUTA}


# Detener y deshabilitar el servicio OpenVPN del servidor
systemctl stop openvpn@${SERVIDOR}
systemctl disable openvpn@${SERVIDOR}

# Ruta al certificado y clave del servidor VPN
CERTIFICATE="/etc/openvpn/"${SERVIDOR}".crt"
PRIVATE_KEY="/etc/openvpn/"${SERVIDOR}".key"
EXISTING_CRL="/etc/openvpn/crl.pem"

# Comando para revocar el certificado y clave del servidor VPN
sudo openssl ca -revoke "$CERTIFICATE" -keyfile "$PRIVATE_KEY" -config "/etc/openvpn/"${SERVIDOR}".conf" -crl_reason unspecified

# Generar una nueva CRL que incluya el certificado revocado
sudo openssl ca -gencrl -config "/etc/openvpn/"${SERVIDOR}".conf" -out "/etc/openvpn/crl.pem"

# Concatenar el certificado revocado a la CRL existente
sudo cat "$EXISTING_CRL" >> "/etc/openvpn/"${SERVIDOR}"/crl.pem"
sudo mv "/etc/openvpn/"${SERVIDOR}"/crl.pem" "$EXISTING_CRL"

# Eliminar los archivos de configuración y certificados del servidor
rm -rf /etc/openvpn/${SERVIDOR}
rm /etc/openvpn/${SERVIDOR}.*


echo "El servidor de OpenVPN \"$SERVIDOR\" ha sido eliminado correctamente."

