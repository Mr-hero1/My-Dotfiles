#!/bin/bash

# --- CONFIGURATION ---
EWW_THEME_DIR="$HOME/.config/eww/theme"
THEME_FILE="$EWW_THEME_DIR/theme.scss"
LIGHT_THEME_SRC="$EWW_THEME_DIR/themelight.scss"
DARK_THEME_SRC="$EWW_THEME_DIR/themedark.scss"

NIRI_CONFIG_DIR="$HOME/.config/niri"
NIRI_THEME_SYMLINK="$NIRI_CONFIG_DIR/theme.kdl"

GTK_LIGHT_THEME="Catppuccin-Light"
GTK_DARK_THEME="Graphite-Dark"

THEME_DIR="$HOME/.themes" 

ICON_LIGHT_THEME="Tela-circle-black-light"
ICON_DARK_THEME="Tela-circle-black-dark"

FOOT_LIGHT_SRC="$HOME/.config/foot/light.ini"
FOOT_DARK_SRC="$HOME/.config/foot/dark.ini"
FOOT_THEME_DEST="$HOME/.config/foot/theme.ini"

HELIX_CONFIG_DIR="$HOME/.config/helix"
HELIX_CONFIG_FILE="$HELIX_CONFIG_DIR/config.toml"

TOFI_CONFIG_DIR="$HOME/.config/tofi"
TOFI_CONFIG_FILE="$TOFI_CONFIG_DIR/config"

apply_gtk4_theme() {
    local theme_name=$1
    mkdir -p "$HOME/.config/gtk-4.0"
    ln -sf "$THEME_DIR/$theme_name/gtk-4.0/assets" "$HOME/.config/gtk-4.0/assets"
    ln -sf "$THEME_DIR/$theme_name/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
    ln -sf "$THEME_DIR/$theme_name/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"
}

# --- THEME SWITCHING LOGIC ---
CURRENT_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme)

if [ "$CURRENT_SCHEME" = "'prefer-light'" ]; then
    # --- SWITCH TO DARK MODE ---
    
    ln -sf "$DARK_THEME_SRC" "$THEME_FILE"
    
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_DARK_THEME"
    gsettings set org.gnome.desktop.interface icon-theme "$ICON_DARK_THEME"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    
    apply_gtk4_theme "$GTK_DARK_THEME"
    
    cp "$FOOT_DARK_SRC" "$FOOT_THEME_DEST"
    ln -sf "$HELIX_CONFIG_DIR/config.toml.dark" "$HELIX_CONFIG_FILE"
    ln -sf "$TOFI_CONFIG_DIR/config.dark" "$TOFI_CONFIG_FILE"
    ln -sf "$NIRI_CONFIG_DIR/theme-dark.kdl" "$NIRI_THEME_SYMLINK"
else
    # --- SWITCH TO LIGHT MODE ---
    
    ln -sf "$LIGHT_THEME_SRC" "$THEME_FILE"
    
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_LIGHT_THEME"
    gsettings set org.gnome.desktop.interface icon-theme "$ICON_LIGHT_THEME"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    
    apply_gtk4_theme "$GTK_LIGHT_THEME"
    
    cp "$FOOT_LIGHT_SRC" "$FOOT_THEME_DEST"
    ln -sf "$HELIX_CONFIG_DIR/config.toml.light" "$HELIX_CONFIG_FILE"
    ln -sf "$TOFI_CONFIG_DIR/config.light" "$TOFI_CONFIG_FILE"
    ln -sf "$NIRI_CONFIG_DIR/theme-light.kdl" "$NIRI_THEME_SYMLINK"
fi

