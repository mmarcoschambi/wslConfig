#!/bin/bash

#definir los nombres de los archivos temporales
INPUT=/tmp/menu.sh.$$
OUTPUT=/tmp/output.sh.$$

# función para limpiar los archivos temporales y salir del script
function cleanup {
	    rm -f $INPUT
	        rm -f $OUTPUT
		    exit
	    }

	    # capturar la señal de salida y llamar a la función cleanup
	    trap cleanup SIGHUP SIGINT SIGTERM

	    # mostrar un menú usando Dialog
	    dialog --clear --backtitle "Mi aplicación" \
		           --title "Materias Apu23" \
			          --menu "Selecciona una opción:" 12 40 5 \
				         1 "PE" \
					 2 "PV" \
					 3 "BDD2" \
					 4 "ALG" \
					 5 "Salir" 2>"${INPUT}"

	    # leer el valor seleccionado del archivo de entrada
	    menuitem=$(<"${INPUT}")

	    # procesar la selección del usuario
	    case $menuitem in
		    1) APU23;;
		    2) echo "Opción 2 seleccionada";;
		    3) echo "Opción 3 seleccionada";;
		    4) echo "Opción 4 seleccionada";;
		    5) echo "Saliendo...";;
	    esac

				# pausa el script para que el usuario pueda ver el resultado
				read -p "Presiona Enter para continuar..."

				# limpiar los archivos temporales y salir del script
				cleanup

