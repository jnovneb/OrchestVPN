#!/bin/bash
cd /etc/openvpn/
# Obtener la lista de todos los archivos de configuración de OpenVPN
config_files=$(find -name "*.conf")

# Comprobar si se encontraron archivos de configuración
if [ -z "$config_files" ]; then
  echo "No se encontraron archivos de configuración de OpenVPN."
  exit 1
fi

# Recorrer la lista de archivos de configuración y activar los servidores OpenVPN
for file in $config_files; do
  filename=$(basename "$file")        # Eliminar la ruta completa
  server_name=$(basename "$filename" .conf)   # Eliminar la extensión .conf

  echo "Iniciando el servidor OpenVPN: $server_name"
  sudo systemctl start openvpn@"$server_name"
done

echo "Todos los servidores OpenVPN han sido iniciados."
exit 0

