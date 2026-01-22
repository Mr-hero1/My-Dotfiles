set -e
get_volume() { pamixer --get-volume; }

show_notif() { 
    # Using x-canonical-private-synchronous instead of dunst-stack-tag
    notify-send -u low -a sysl -t 2000 \
    -h string:x-canonical-private-synchronous:osd \
    -h int:value:"$2" "$1" 
}

rate_limit() {
    local f=/tmp/last_$1 now
    now=$(date +%s%3N)
    [[ -f $f && $((now - $(<"$f"))) -lt 500 ]] && return 1
    echo "$now" > "$f"
}

# --- Main actions ---
case $1 in
    volume_up|volume_down)
    pamixer --unmute
    if [[ $1 == volume_up ]]; then
        vol=$(( $(get_volume) + 2 ))
        (( vol > 100 )) && vol=100
    else
        vol=$(( $(get_volume) - 2 ))
        (( vol < 0 )) && vol=0
    fi
    pamixer --set-volume "$vol"
    show_notif "[VOLUME LEVEL]" "$vol"
    ;;
    volume_mute)
        rate_limit volume_mute || exit
        pamixer --toggle-mute
        show_notif "$([[ $(pamixer --get-mute) == true ]] && echo '[VOLUME MUTE]' || echo '[VOLUME LEVEL]')" "$([[ $(pamixer --get-mute) == true ]] && echo 0 || echo $(get_volume))"
        ;;
esac
