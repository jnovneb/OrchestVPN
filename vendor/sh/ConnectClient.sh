#!/bin/bash

# Verifica si el script se está ejecutando con privilegios de superusuario
if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ejecutarse como superusuario" 
   exit 1
fi

# Verifica si se ha proporcionado un argumento para la ruta del archivo de configuración
if [[ $# -ne 1 ]]; then
    echo "Uso: $0 <ruta_al_archivo>"
    exit 1
fi

# Ruta al archivo de configuración del cliente OpenVPN
CONFIG_FILE="$1"

# Verifica si el archivo de configuración existe
if [[ ! -f $CONFIG_FILE ]]; then
    echo "No se encuentra el archivo de configuración del cliente OpenVPN: $CONFIG_FILE"
    exit 1
fi

# Inicia la conexión OpenVPN
openvpn --config "$CONFIG_FILE"
