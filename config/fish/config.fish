if status is-interactive
    set -g fish_greeting ""
    alias anime='viu'
    alias up='sudo pacman -Syu'
    alias cam='scrcpy --video-source=camera --v4l2-sink=/dev/video9 --video-source=camera --v4l2-sink=/dev/video9 --no-playback --no-audio --no-window  --camera-id=0 --camera-size=1920x1080 --video-bit-rate=4M'
    alias cam-on='sudo modprobe v4l2loopback exclusive_caps=1 video_nr=9 card_label="Android-Webcam"'
    set -gx EDITOR helix
end

pfetch
