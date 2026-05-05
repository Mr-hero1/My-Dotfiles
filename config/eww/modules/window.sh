get_title() {
    niri msg -j focused-window | jq -r '.title // ""' 2>/dev/null
}

get_title

niri msg -j event-stream | jq --unbuffered -c 'select(.WindowFocusChanged or .WindowTitleChanged)' | while read -r _; do
    get_title
done
