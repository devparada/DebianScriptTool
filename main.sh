#! /bin/bash

usuario=$(whoami)

# Verifica si se ejecuta como root
if [[ $EUID != 0 ]]
then
    echo "Este script necesita permisos de root"
        if groups $usuario | grep -q '\bsudo\b'
        then
            echo "Introduce la contraseña de tu usuario:"
            exec sudo "$0" "$@" $(whoami)
        else 
            echo "Introduce la contraseña de root"
            exec su -c "$0" "$@"
        fi
        # Si la contraseña es invalida sale del programa
        exit 1
fi

# Para que cuando reinicie el script se guarde al usuario que ejecute el script
usuario=$1
echo "Contraseña válida"
echo === Debian Script Tool ===
echo "Bienvienido, $usuario a este script para personalizar Debian a tu gusto"
echo "A continuación le haremos unas preguntas:"
echo "¿Agregar a este usuario al grupo sudo para usar sudo su? (S/N):"
read opcion1

# Si la respuesta es S se ejecuta sino muestra el mensaje
if [[ $opcion1 == S ]]
then
    echo "Agregando este usuario al grupo sudo..."
    usermod -aG sudo $usuario
else
    echo "No se agrego el usuario al grupo sudo"
fi

echo "¿Añadir al PATH las rutas para ejecutar los programas de /bin y usr/bin de tu usuario? (S/N)"
read opcion2

if [[ $opcion2 == S ]]
then
    ruta="/home/$usuario"
    archivo1="$ruta/.bashrc"
    if [ -f $archivo1 ]
    then
        cat $archivo1 > $ruta/.bashrc-seguridad
        echo export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin" >> $archivo1
        echo "Listo"
    fi
fi

echo "¿Añadir al PATH las rutas para ejecutar los programas de /bin y usr/bin del root? (S/N)"
read opcion3

if [[ $opcion3 == S ]]
then
    ruta="/root"
    archivo2="/root/.bashrc"
    if [ -f $archivo2 ]
    then
        cat $archivo2 > $ruta/.bashrc-seguridad
        echo export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin" >> $archivo2
        echo "Listo"
    fi
fi
