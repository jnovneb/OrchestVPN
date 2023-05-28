#!/bin/bash

# Comprueba si se proporcionó un argumento
if [ -z "$1" ]; then
  echo "No se proporcionó ningún argumento."
  exit 1
fi

# Guarda el argumento en una variable
string="$1"
ruta="$2"

# Imprime el string
echo "El nombre es: $string"
echo "La ruta es: $ruta"
