#!/bin/bash

# Verificar si el script se ejecuta con privilegios de superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse con privilegios de superusuario."
  exit 1
fi

# Verificar si se proporcionaron suficientes argumentos
if [ $# -lt 2 ]; then
  echo "Uso: $0 <ruta> <NOMBRE_DEL_CLIENTE> <CONTRASEÑA OPCIONAL> <SERVER>"
  exit 1
fi

RUTA="$1"
CLIENT="$2"
SERVER="$3"
CONTRASENA="$4"


# Verificar si el cliente ya existe
CLIENTEXISTS=$(tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep -c -E "/CN=$CLIENT\$")
if [[ $CLIENTEXISTS == '1' ]]; then
  echo ""
  echo "El cliente especificado ya existe en easy-rsa, por favor elige otro nombre."
  exit
fi


# Determinar si se utiliza tls-auth o tls-crypt
if grep -qs "^tls-crypt" "/etc/openvpn/$SERVER.conf"; then
  TLS_SIG="1"
elif grep -qs "^tls-auth" "/etc/openvpn/$SERVER.conf"; then
  TLS_SIG="2"
fi

echo "El valor de server es: $SERVER"

# Generar el cliente utilizando easyrsa
cd /etc/openvpn/easy-rsa/ || exit
case $CONTRASENA in
  "")
  
    ./easyrsa --batch build-client-full "$CLIENT" nopass

    ;;
  *)
    echo "⚠️ Se te solicitará la contraseña del cliente a continuación ⚠️"
    ./easyrsa --batch build-client-full "$CLIENT"

    ;;
esac
# Generar el archivo de configuración personalizado client.ovpn
cp "/etc/openvpn/client-template-$SERVER.txt" "$RUTA/$CLIENT.ovpn"

{
  echo "<ca>"
  cat "/etc/openvpn/easy-rsa/pki/ca.crt"
  echo "</ca>"

  echo "<cert>"
  awk '/BEGIN/,/END CERTIFICATE/' "/etc/openvpn/easy-rsa/pki/issued/$CLIENT.crt"
  echo "</cert>"

  echo "<key>"
  cat "/etc/openvpn/easy-rsa/pki/private/$CLIENT.key"
  echo "</key>"

  case $TLS_SIG in
    1)
      echo "<tls-crypt>"
      cat /etc/openvpn/tls-crypt.key
      echo "</tls-crypt>"
      ;;
    2)
      echo "key-direction 1"
      echo "<tls-auth>"
      cat /etc/openvpn/tls-auth.key
      echo "</tls-auth>"
      ;;
  esac
} >> "$RUTA/$CLIENT.ovpn"

echo ""
echo "El archivo de configuración se ha escrito en $RUTA/$CLIENT.ovpn."
echo "Descarga el archivo .ovpn e impórtalo en tu cliente OpenVPN."

