#!/bin/bash

# Verificar si el script se ejecuta con privilegios de superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse con privilegios de superusuario."
  exit 1
fi

# Verificar si se proporcionaron suficientes argumentos
if [ $# -lt 3 ]; then
  echo "Uso: $0 <NOMBRE_DEL_CLIENTE> <IP_DEL_SERVIDOR> <PUERTO_DEL_SERVIDOR> [CONTRASENA] [ANCHO_DE_BANDA]"
  exit 1
fi

# Asignar argumentos a variables
CLIENT="$1"
IP_SERVIDOR="$2"
PUERTO_SERVIDOR="$3"
CONTRASENA="$4"
ANCHO_DE_BANDA="$5"

# Verificar si el cliente ya existe
CLIENTEXISTS=$(tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep -c -E "/CN=$CLIENT\$")
if [[ $CLIENTEXISTS == '1' ]]; then
  echo ""
  echo "El cliente especificado ya existe en easy-rsa, por favor elige otro nombre."
  exit
fi

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
echo "Cliente $CLIENT añadido."

# Directorio principal del usuario, donde se escribirá la configuración del cliente
if [ -e "/home/${CLIENT}" ]; then
  # Si $1 es un nombre de usuario
  homeDir="/home/${CLIENT}"
elif [ "${SUDO_USER}" ]; then
  # Si no, utiliza SUDO_USER
  if [ "${SUDO_USER}" == "root" ]; then
    # Si se ejecuta sudo como root
    homeDir="/root"
  else
    homeDir="/home/${SUDO_USER}"
  fi
else
  # Si no hay SUDO_USER, utiliza /root
  homeDir="/root"
fi

# Crear la carpeta del cliente con los permisos adecuados
clientDir="$homeDir/$CLIENT"
mkdir -p "$clientDir"
chown -R "$SUDO_USER:$SUDO_USER" "$clientDir"

# Determinar si se utiliza tls-auth o tls-crypt
if grep -qs "^tls-crypt" /etc/openvpn/server.conf; then
  TLS_SIG="1"
elif grep -qs "^tls-auth" /etc/openvpn/server.conf; then
  TLS_SIG="2"
fi

# Genera el archivo de configuración personalizado client.ovpn
cp /etc/openvpn/client-template.txt "$clientDir/$CLIENT.ovpn"
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
} >>"$clientDir/$CLIENT.ovpn"

echo ""
echo "El archivo de configuración se ha escrito en $clientDir/$CLIENT.ovpn."
echo "Descarga el archivo .ovpn e impórtalo en tu cliente OpenVPN."
