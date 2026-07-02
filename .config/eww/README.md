# Eww Configuration Notes

This directory contains the Eww bar and widget configurations for the Niri desktop setup.
├── control.yuck
├── eww.scss
├── eww.yuck
├── modules
│   ├── backlight.sh
│   ├── bluetooth.sh
│   ├── info.sh
│   ├── kay.sh
│   ├── notify.sh
│   ├── opener.sh
│   ├── theme.sh
│   ├── thum.sh
│   ├── timer.sh
│   ├── volume.sh
│   ├── wifi.sh
│   ├── window.sh
│   └── workspaces.sh
├── notification.yuck
└── theme
    ├── themedark.scss
    ├── themelight.scss
    └── theme.scss
    
## Theme Switching (Light/Dark Mode)
* **Eww:** Swaps SCSS asset roots.
* **GTK 3/4:** Modifies `gsettings` properties and configurations.
* **Foot, Helix, Tofi, & Niri:** Swaps targeted theme components dynamically.
* **Wallpapers:** Targets system wallpapers through `awww`.

## Dependencies

| Component Type | Dependency Package | Purpose |
| :--- | :--- | :--- |
| **Fonts & Icons** | `ttf-jetbrains-mono-nerd`, `material-design-icons` | Text layout and glyph rendering for bars/widgets |
| **Audio** | `pamixer`, `pactl`, `playerctl` | Volume feeds, mute hooks, and MPRIS media controller processing |
| **Display** | `brightnessctl`, `inotify-tools`, `wlsunset` | Instant backlight polling and blue-light nightlight filter toggling |
| **Desktop Environment** | `niri`, `jq`, `awk`, `wl-clipboard` | Real-time streams, layout processing, and hex code copy operations |
| **Peripherals** | `bluez-utils` (`bluetoothctl`), `overskride` | Connected Bluetooth devices and connection configuration GUI |
| **Notifications** | `tiramisu` | Lightweight desktop notification multiplexing |
| **Network Manager** | `networkmanager` (`nmcli`), `nmrs` | Active network profile tracking and interactive network selector |
| **Miscellaneous Utilities**| `awww`, `libnotify` (`notify-send`) | Wallpaper updates and fallback notification banners for timers |

