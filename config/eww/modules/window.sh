get_title() {
niri msg -j focused-window | jq -r '.title // "~"' 2>/dev/null | awk '{ if (length($0) > 100) print substr($0, 1, 97) "..."; else print $0; }'
}

get_title

niri msg -j event-stream | jq --unbuffered -c 'select(.WindowFocusChanged or .WindowTitleChanged)' | while read -r _; do
    get_title
done
