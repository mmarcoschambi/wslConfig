#!/bin/bash

# Definir los nombres de los archivos temporales
INPUT=/tmp/menu.sh.$$
OUTPUT=/tmp/output.sh.$$

# Función para limpiar los archivos temporales y salir del script
function cleanup {
  rm -f $INPUT
  rm -f $OUTPUT
  exit
}

# Función para buscar y mostrar archivos PDF en la ruta de la materia
function search_pdf {
  materia=$1
  ruta="/mnt/c/Users/Infam/OneDrive/Documentos/pc/UnJu21/APU/2023/$materia"

  # Buscar archivos PDF en la ruta especificada
  pdf_files=$(find "$ruta" -type f -name "*.pdf")

  if [ -z "$pdf_files" ]; then
    dialog --title "Archivos PDF encontrados" --msgbox "No se encontraron archivos PDF en la ruta de la materia." 8 40
  else
    dialog --title "Archivos PDF encontrados" --msgbox "Archivos PDF encontrados en la ruta de la materia:\n\n$pdf_files" 12 60
  fi
}

# Capturar la señal de salida y llamar a la función cleanup
trap cleanup SIGHUP SIGINT SIGTERM

# Mostrar un cuadro de diálogo para ingresar el nombre de la materia
dialog --clear --backtitle "Búsqueda de archivos PDF" \
  --inputbox "Ingrese el nombre de la materia:" 8 40 2>"${INPUT}"

# Leer el valor ingresado del archivo de entrada
materia=$(<"${INPUT}")

# Eliminar espacios en blanco al inicio y al final del nombre de la materia
materia=$(echo "$materia" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')

# Verificar si se ingresó un nombre de materia válido
if [ -z "$materia" ]; then
  dialog --title "Error" --msgbox "No se ingresó un nombre de materia válido." 8 40
else
  # Llamar a la función para buscar y mostrar archivos PDF en la ruta de la materia
  search_pdf "$materia"
fi

# Pausa el script para que el usuario pueda ver el resultado
read -p "Presiona Enter para continuar..."

# Limpiar los archivos temporales y salir del script
cleanup
