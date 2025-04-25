#!/bin/bash/

# Lista de IPs o nombres de host
HOSTS=($(tail -n +2 datosDebian.csv | awk -F',' '{print $5}' | sort -u | tail -n +2 |  paste -sd' '))
printf "$HOSTS"
#$(tail -n +2 datosDebian.csv | awk -F',' '{print $5}' | sort -u)
#$(tail -n +2 datosDebian.csv | awk -F',' '{print $5}')
#$(tail -n +2 datosDebian.csv | awk -F',' '{print $5}') | paste -s
#$(cat "$1" | tr ',' ' ')
#paste -s $(tail -n +2 datosDebian.csv | awk -F',' '{print $5}' )


echo "==== Verificando computadoras Debian activas y obteniendo información remota ===="

#check_remote_host() {
 #   local HOST="$1"
for HOST in "${HOSTS[@]}"; do

    if ping -c 1 -W 1 "$HOST" &> /dev/null; then
        echo -e "\n✅ [$HOST] está activa"

        echo "--- Usuarios conectados en $HOST ---"
        ssh -o ConnectTimeout=2 "$HOST" "who" 2>/dev/null || echo "Error obteniendo usuarios"

        echo "--- Tiempo de actividad en $HOST ---"
        ssh -o ConnectTimeout=2 "$HOST" "uptime -p" 2>/dev/null || echo "Error obteniendo uptime"

    else
        echo -e "\n❌ [$HOST] no responde al ping"
    fi
done
#}

#export -f check_remote_host
#printf "%s\n" "${HOSTS[@]}" | check_remote_host
