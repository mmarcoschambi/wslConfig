#!/bin/bash

# Definir los nombres de los archivos temporales
INPUT=/tmp/menu.sh.$$
OUTPUT=/tmp/output.sh.$$

# Ruta base
RUTA="/mnt/c/Users/Infam/OneDrive/Documentos/pc/UnJu21/APU/2023/"

# Función para limpiar los archivos temporales y salir del script
function cleanup {
    rm -f "$INPUT"
    rm -f "$OUTPUT"
    exit
}

# Capturar la señal de salida y llamar a la función cleanup
trap cleanup SIGHUP SIGINT SIGTERM

# Función para abrir el archivo PDF usando wslview
function abrir_pdf {
    wslview "$1" &
}

# Mostrar un menú usando Dialog
dialog --clear --backtitle "Mi aplicación" \
    --title "Materias Apu23" \
    --menu "Selecciona una opción:" 12 80 5 \
    1 "PE" \
    2 "PV" \
    3 "BDD2" \
    4 "ALG" \
    5 "Salir" 2>"${INPUT}"

# Leer el valor seleccionado del archivo de entrada
menuitem=$(<"${INPUT}")

# Procesar la selección del usuario
case $menuitem in
    1) materia="PE";;
    2) materia="PV";;
    3) materia="BDD2";;
    4) materia="ALG";;
    5) echo "Saliendo..." && cleanup;;
esac

# Buscar archivos PDF en la ruta correspondiente a la materia seleccionada
mapfile -d $'\0' pdf_files < <(find "$RUTA/$materia" -iname "*.pdf" -print0)

# Crear un array para almacenar los archivos seleccionados
selected_files=()

# Mostrar un nuevo menú con los archivos PDF encontrados
while true; do
    options=()
    for file in "${pdf_files[@]}"; do
        options+=("$file" "$(basename "$file")")
    done

    dialog --clear --backtitle "Mi aplicación" \
        --title "Archivos PDF de $materia" \
        --menu "Selecciona un archivo PDF (Espacio para seleccionar, Enter para abrir):" 16 120 10 "${options[@]}" 2>"${OUTPUT}"

    # Leer los archivos PDF seleccionados del archivo de salida
    IFS=$'\n' read -r -d '' -a selected <<< "$(cat "${OUTPUT}")"

    # Salir del bucle si no se seleccionó ningún archivo
    [[ ${#selected[@]} -eq 0 ]] && break

    # Agregar los archivos seleccionados al array
    selected_files+=("${selected[@]}")

    # Eliminar los archivos seleccionados del array de archivos disponibles
    for file in "${selected[@]}"; do
        pdf_files=("${pdf_files[@]/$file}")
    done
done

# Abrir los archivos PDF seleccionados usando wslview
for file in "${selected_files[@]}"; do
    abrir_pdf "$file"
done

# Pausar el script para que el usuario pueda ver el resultado
read -p "Presiona Enter para continuar..."

# Limpiar los archivos temporales y salir del script
cleanup

