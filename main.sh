#! /bin/bash

usuario=$(whoami)

# Verifica si se ejecuta como root
if [[ $EUID != 0 ]]
then
    echo "Este script necesita permisos de root"
        if groups $usuario | grep -q '\bsudo\b'
        then
            echo "Introduce la contraseña de tu usuario:"
            exec sudo "$0" "$@"
        else 
            echo "Introduce la contraseña de root"
            exec su -c "$0" "$@"
        fi
        # Si la contraseña es invalida sale del programa
        exit 1
else
    echo "Este script es necesario que lo ejecutes como usuario"
fi

# Función que modifica el bash
function modificarBash() {
    # Comprueba si el archivo existe
    if [ -f $1 ]
    then
        cat $1 > $ruta/.bashrc-seguridad
        echo export PATH=""/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"" >> $1
    fi
}

# Para que cuando reinicie el script se guarde al usuario que ejecute el script con o sin sudo
usuario=$(logname 2>/dev/null)
echo === Debian Script Tool ===
echo "Bienvienido, $usuario a este script para personalizar Debian a tu gusto"
echo "A continuación le haremos unas preguntas:"

echo "¿Actualiza el sistema? (S/N):"
read opcion1

if [[ $opcion1 == S ]]
then
    echo "Actualizando el sistema"
    apt update -y
    apt upgrade -y
fi

echo
echo "¿Agregar a este usuario al grupo sudo para usar sudo su? (S/N):"
read opcion2

# Si la respuesta es S se ejecuta sino muestra el mensaje
if [[ $opcion2 == S ]]
then
    echo "Agregando este usuario al grupo sudo..."
    usermod -aG sudo $usuario
else
    echo "No se agrego el usuario al grupo sudo"
fi

echo
echo "¿Añadir al PATH las rutas para ejecutar los programas de /bin y usr/bin de tu usuario y root? (S/N)"
read opcion3

if [[ $opcion3 == S ]]
then
    ruta="/home/$usuario"
    archivoBashrc="/home/$usuario/.bashrc"

    # Llama a la función y pasa la ruta como primer parámetro
    modificarBash $archivoBashrc

    ruta="/root"
    archivoBashrc="/root/.bashrc"

    modificarBash $archivoBashrc
    echo "Añadido al PATH del $usuario y del root"
fi
