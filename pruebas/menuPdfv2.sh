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
    options=()
    for file in $pdf_files; do
      # Recortar la ruta y agregar a la lista de opciones
      trimmed_path=$(echo "$file" | sed "s|$ruta/||")
      options+=("$trimmed_path" "" off)
    done

    # Mostrar el menú de selección con casillas de verificación
    dialog --backtitle "Archivos PDF encontrados" \
      --title "Archivos PDF en la ruta de la materia" \
      --checklist "" 12 60 8 "${options[@]}" 2>"$OUTPUT"

    # Leer las selecciones del archivo de salida
    selections=$(<"$OUTPUT")

    # Procesar las selecciones de archivos PDF
    for selection in $selections; do
      # Obtener la ruta completa del archivo seleccionado
      selected_file="$ruta/$selection"

      # Mostrar el archivo PDF utilizando wslview
      wslview "$selected_file"
    done
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

# Limpiar los archivos temporales y salir del script
cleanup
