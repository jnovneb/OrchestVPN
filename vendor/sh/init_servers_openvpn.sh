#!/bin/bash

# Obtener la lista de todos los archivos de configuración de OpenVPN
config_files=$(find /etc/openvpn/ -name "*.conf")

# Comprobar si se encontraron archivos de configuración
if [ -z "$config_files" ]; then
  echo "No se encontraron archivos de configuración de OpenVPN."
  exit 1
fi

# Recorrer la lista de archivos de configuración y activar los servidores OpenVPN
for file in $config_files; do
  echo "Iniciando el servidor OpenVPN: $file"
  sudo systemctl start openvpn@$(basename "$file" .conf)
done

echo "Todos los servidores OpenVPN han sido iniciados."
exit 0

