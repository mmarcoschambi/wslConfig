#!/bin/bash

# Función para procesar la selección de la materia
function process_materia {
  materia=$1
  echo "Materia seleccionada: $materia"
  select_recursos
}

# Función para mostrar un menú de selección de recursos
function select_recursos {
  resources=("*.pdf" "Aula virtual" "Páginas guardas" "Zoom" "Programa/IDE") # Recursos disponibles
  selected=() # Array para almacenar los recursos seleccionados

  while true; do
    selected_resource=$(dialog --clear --backtitle "Seleccionar Recursos" --title "Seleccione los recursos:" --menu "" 12 50 8 "${resources[@]}" 2>&1 >/dev/tty)

    case $selected_resource in
      "*.pdf")
        process_pdf
        ;;
      "Aula virtual")
        process_aula_virtual
        ;;
      "Páginas guardas")
        process_paginas_guardas
        ;;
      "Zoom")
        process_zoom
        ;;
      "Programa/IDE")
        process_programa_ide
        ;;
      *)
        break
        ;;
    esac
  done
}

# Función para procesar la selección de PDF
function process_pdf {
  # Aquí puedes agregar la lógica para procesar la selección de PDF
  echo "Recursos PDF seleccionados"
}

# Función para procesar la selección de Aula virtual
function process_aula_virtual {
  # Aquí puedes agregar la lógica para procesar la selección de Aula virtual
  echo "Recursos Aula virtual seleccionados"
}

# Función para procesar la selección de Páginas guardas
function process_paginas_guardas {
  # Aquí puedes agregar la lógica para procesar la selección de Páginas guardas
  echo "Recursos Páginas guardas seleccionados"
}

# Función para procesar la selección de Zoom
function process_zoom {
  # Aquí puedes agregar la lógica para procesar la selección de Zoom
  echo "Recursos Zoom seleccionados"
}

# Función para procesar la selección de Programa/IDE
function process_programa_ide {
  # Aquí puedes agregar la lógica para procesar la selección de Programa/IDE
  echo "Recursos Programa/IDE seleccionados"
}

# Definir los nombres de los archivos temporales
INPUT=/tmp/menu.sh.$$
OUTPUT=/tmp/output.sh.$$

# Función para limpiar los archivos temporales y salir del script
function cleanup {
  rm -f $INPUT
  rm -f $OUTPUT
  exit
}

# Capturar la señal de salida y llamar a la función cleanup
trap cleanup SIGHUP SIGINT SIGTERM

# Mostrar un menú usando Dialog
dialog --clear --backtitle "Mi aplicación" \
  --title "Materias Apu23" \
  --menu "Selecciona una opción:" 12 40 5 \
  1 "PE" \
  2 "PV" \
  3 "BDD2" \
  4 "ALG" \
  5 "Salir" 2>"${INPUT}"

# Leer el valor seleccionado del archivo de entrada
menuitem=$(<"${INPUT}")

# Procesar la selección del usuario
case $menuitem in
  1) process_materia "PE";;
  2) process_materia "PV";;
  3) process_materia "BDD2";;
  4) process_materia "ALG";;
  5) echo "Saliendo...";;
esac

# Pausa el script para que el usuario pueda ver el resultado
read -p "Presiona Enter para continuar..."

# Limpiar los archivos temporales y salir del script
cleanup
