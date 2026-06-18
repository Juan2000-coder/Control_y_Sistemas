#!/bin/bash

# 1. Verificar si se pasó el archivo como argumento
if [ -z "$1" ]; then
    echo "Falta el archivo. Uso: $0 archivo.html"
    exit 1
fi

ARCHIVO="$1"

# 2. Verificar si el archivo existe
if [ ! -f "$ARCHIVO" ]; then
    echo "Error: El archivo '$ARCHIVO' no existe."
    exit 1
fi

echo "Abriendo '$ARCHIVO' en tu navegador predeterminado de Windows..."

# 3. Forzar la ejecución llamando directamente al cmd.exe original de Windows
# Se usa 'wslpath -w' para convertir la ruta de Linux (/mnt/c/...) a formato Windows (C:\...)
PATH_WINDOWS=$(wslpath -w "$ARCHIVO")

/mnt/c/Windows/System32/cmd.exe /c start "" "$PATH_WINDOWS"
