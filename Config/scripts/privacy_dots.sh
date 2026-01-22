#!/usr/bin/env bash
# dependencies: pipewire (pw-dump), v4l2loopback-dkms, jq, dbus-send (dbus), fuser, ps, pgrep
set -euo pipefail

JQ_BIN="${JQ:-jq}"
PW_DUMP_CMD="${PW_DUMP:-pw-dump}"

mic=0
cam=0
loc=0
scr=0

mic_app=""
cam_app=""
loc_app=""
scr_app=""

# --- Check for Mic and Camera status (PipeWire and fuser) ---
if command -v "$PW_DUMP_CMD" >/dev/null 2>&1 && command -v "$JQ_BIN" >/dev/null 2>&1; then
  # Get PipeWire dump once
  dump="$($PW_DUMP_CMD 2>/dev/null || true)"

  # Check Mic status
  mic="$(
    printf '%s' "$dump" \
    | $JQ_BIN -r '
      [ .[]
        | select(.type=="PipeWire:Interface:Node")
        | select((.info.props."media.class"=="Audio/Source" or .info.props."media.class"=="Audio/Source/Virtual"))
        | select((.info.state=="running") or (.state=="running"))
      ] | (if length>0 then 1 else 0 end)
    ' 2>/dev/null || echo 0
  )"

  # Get Mic app names (no longer used in output, but kept for completeness if needed later)
  if [[ "$mic" -eq 1 ]]; then
    mic_app="$(
      printf '%s' "$dump" \
      | $JQ_BIN -r '
        [ .[]
          | select(.type=="PipeWire:Interface:Node")
          | select((.info.props."media.class"=="Stream/Input/Audio"))
          | select((.info.state=="running") or (.state=="running"))
          | .info.props["node.name"]
        ] | unique | join(", ")
      ' 2>/dev/null || echo ""
    )"
  fi

  # Check Camera status and get app names (using fuser on /dev/video*)
  if command -v fuser >/dev/null 2>&1 && command -v ps >/dev/null 2>&1; then
    for dev in /dev/video*; do
      if [ -e "$dev" ] && fuser "$dev" >/dev/null 2>&1; then
        cam=1 # Set camera status to ON
        pids=$(fuser "$dev" 2>/dev/null)
        for pid in $pids; do
          pname=$(ps -p "$pid" -o comm=)
          if [[ -n "$pname" ]]; then
            cam_app+="$pname, "
          fi
        done
      fi
    done
    cam_app="${cam_app%, }" # Remove trailing comma and space
  else
    cam=0
  fi
fi

# --- Check for Location status (Geoclue process) ---
if command -v pgrep >/dev/null 2>&1 && command -v ps >/dev/null 2>&1; then
    if pids=$(pgrep -x geoclue); then
        loc=1 # Set location status to ON
        for pid in $pids; do
            pname=$(ps -p "$pid" -o comm=)
            [[ -n "$pname" ]] && loc_app+="$pname, "
        done
        loc_app="${loc_app%, }" # Remove trailing comma and space
    else
        loc=0
    fi
fi

# --- Check for Screen Sharing status (PipeWire nodes) ---
if command -v "$PW_DUMP_CMD" >/dev/null 2>&1 && command -v "$JQ_BIN" >/dev/null 2>&1; then
  # Re-use dump if it exists
  if [[ -z "${dump:-}" ]]; then
    dump="$($PW_DUMP_CMD 2>/dev/null || true)"
  fi

  scr="$(
    printf '%s' "$dump" \
    | $JQ_BIN -e '
      [ .[]
        | select(.info?.props?)
        | select(
          (.info.props["media.name"]? // "")
          | test("^(xdph-streaming|gsr-default|game capture)")
        )
      ]
      | (if length > 0 then true else false end)
    ' >/dev/null && echo 1 || echo 0
  )"

  # Get Screen Sharing app names
  if [[ "$scr" -eq 1 ]]; then
    scr_app="$(
    printf '%s' "$dump" \
    | $JQ_BIN -r '
        [ .[]
          | select(.type=="PipeWire:Interface:Node")
          | select((.info.props."media.class"=="Stream/Input/Video") or (.info.props."media.name"=="gsr-default_output") or (.info.props."media.name"=="game capture"))
          | select((.info.state=="running") or (.state=="running"))
          | .info.props["media.name"]
        ] | unique | join(", ")
      ' 2>/dev/null || echo ""
    )"
  fi
fi


# --- Output Formatting (Icons Only) ---
mic_icon=""
cam_icon="󰭩"
loc_icon=""
scr_icon="󱣵"

# Collect all active icons, separated by a space
icons=()
[[ "$mic" -eq 1 ]] && icons+=("$mic_icon")
[[ "$cam" -eq 1 ]] && icons+=("$cam_icon")
[[ "$loc" -eq 1 ]] && icons+=("$loc_icon")
[[ "$scr" -eq 1 ]] && icons+=("$scr_icon")

# Print the space-separated string of active icons
printf '%s\n' "${icons[*]}"   
