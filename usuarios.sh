#!/bin/bash/

# Lista de IPs o nombres de host
HOSTS=$(cat "$1" | tr ',' ' ')


echo "==== Verificando computadoras Debian activas y obteniendo información remota ===="

check_remote_host() {
    local HOST="$1"
    
    if ping -c 1 -W 1 "$HOST" &> /dev/null; then
        echo -e "\n✅ [$HOST] está activa"

        echo "--- Usuarios conectados en $HOST ---"
        ssh -o ConnectTimeout=2 "$HOST" "who" 2>/dev/null || echo "Error obteniendo usuarios"

        echo "--- Tiempo de actividad en $HOST ---"
        ssh -o ConnectTimeout=2 "$HOST" "uptime -p" 2>/dev/null || echo "Error obteniendo uptime"

    else
        echo -e "\n❌ [$HOST] no responde al ping"
    fi
}

export -f check_remote_host
printf "%s\n" "${HOSTS[@]}" | parallel -j 5 check_remote_host
