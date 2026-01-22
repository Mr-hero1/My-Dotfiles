set -e

get_mic_status() {
    local mic mute vol
    mic=$(pactl info | awk -F': ' '/Default Source:/ {print $2}')
    mute=$(pactl get-source-mute "$mic" | awk '{print $2}')
    vol=$(pactl get-source-volume "$mic" | grep -o '[0-9]\{1,3\}%' | head -n1 | tr -d '%')
    echo "$mute" "$vol"
}

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
    mic_mute)
        rate_limit mic_mute || exit
        mic=$(pactl info | awk -F': ' '/Default Source:/ {print $2}')
        pactl set-source-mute "$mic" toggle
        read -r mute vol < <(get_mic_status)
        show_notif "$([[ $mute == yes ]] && echo '[MIC MUTED]' || echo '[MIC LEVEL]')" "$([[ $mute == yes ]] && echo 0 || echo $vol)"
        ;;
esac
