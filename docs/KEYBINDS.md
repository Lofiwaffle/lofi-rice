# Keybinding Reference

Complete keybinding reference for the lofi-rice Hyprland setup.

## 🗂️ Contents

- [Custom Application Shortcuts](#custom-application-shortcuts)
- [Window Management](#window-management)
- [Workspace Management](#workspace-management)
- [System Utilities](#system-utilities)
- [Media Controls](#media-controls)
- [Special Functions](#special-functions)

---

## Custom Application Shortcuts

These are defined in `~/.config/hypr/custom/keybinds.conf`

### Productivity Apps

| Keybind | Application |
|---------|-------------|
| `Super + Shift + Return` | Warp Terminal |
| `Super + O` | Obsidian (with Wayland IME support) |
| `Super + Shift + D` | Discord |
| `Super + Shift + Alt + C` | Cursor IDE |
| `Super + Shift + N` | NotebookLM |

### Web Applications

| Keybind | Application |
|---------|-------------|
| `Super + Alt + X` | ChatGPT |
| `Super + Shift + Alt + A` | Google Gemini |
| `Super + R` | Reddit |
| `Super + Shift + G` | Gmail |
| `Super + Alt + G` | Google Messages |
| `Super + U` | Unifi Dashboard |

### System Monitoring

| Keybind | Application |
|---------|-------------|
| `Super + Alt + T` | Activity Monitor (btop) |

---

## Window Management

Defined in `~/.config/hypr/hyprland/keybinds.conf`

### Basic Window Operations

| Keybind | Action |
|---------|--------|
| `Super + Q` | Close active window |
| `Super + F` | Toggle fullscreen |
| `Super + D` | Maximize window |
| `Super + Alt + Space` | Toggle floating |
| `Super + P` | Pin window (keep on all workspaces) |

### Window Focus

| Keybind | Action |
|---------|--------|
| `Super + Left` | Focus window to the left |
| `Super + Right` | Focus window to the right |
| `Super + Up` | Focus window above |
| `Super + Down` | Focus window below |
| `Super + H` | Focus left (vim-style) |
| `Super + L` | Focus right (vim-style) |
| `Super + K` | Focus up (vim-style) |
| `Super + J` | Focus down (vim-style) |

### Window Movement

| Keybind | Action |
|---------|--------|
| `Super + Shift + Left` | Move window left |
| `Super + Shift + Right` | Move window right |
| `Super + Shift + Up` | Move window up |
| `Super + Shift + Down` | Move window down |
| `Super + Shift + H` | Move window left (vim) |
| `Super + Shift + L` | Move window right (vim) |
| `Super + Shift + K` | Move window up (vim) |
| `Super + Shift + J` | Move window down (vim) |

### Window Resizing

| Keybind | Action |
|---------|--------|
| `Super + Ctrl + Left` | Resize window narrower |
| `Super + Ctrl + Right` | Resize window wider |
| `Super + Ctrl + Up` | Resize window taller |
| `Super + Ctrl + Down` | Resize window shorter |

### Mouse Operations

| Keybind | Action |
|---------|--------|
| `Super + LMB` | Move window (drag) |
| `Super + RMB` | Resize window (drag) |

---

## Workspace Management

### Switching Workspaces

| Keybind | Action |
|---------|--------|
| `Super + 1` through `9` | Switch to workspace 1-9 |
| `Super + 0` | Switch to workspace 10 |
| `Super + Mouse Wheel Up` | Next workspace |
| `Super + Mouse Wheel Down` | Previous workspace |
| `Super + Tab` | Cycle through recent workspaces |

### Moving Windows to Workspaces

| Keybind | Action |
|---------|--------|
| `Super + Alt + 1` through `9` | Move window to workspace 1-9 |
| `Super + Alt + 0` | Move window to workspace 10 |
| `Super + Shift + Alt + 1-9` | Move window silently (don't follow) |

### Special Workspaces

| Keybind | Action |
|---------|--------|
| `Super + S` | Toggle scratchpad workspace |
| `Super + Shift + S` | Move window to scratchpad |

---

## System Utilities

### Core Applications

| Keybind | Application |
|---------|-------------|
| `Super + Return` | Terminal (Kitty) |
| `Super + E` | File manager |
| `Super + W` | Web browser |
| `Super + C` | Code editor |
| `Super + Space` | Application launcher (Rofi/Fuzzel) |

### Screenshots

| Keybind | Action |
|---------|--------|
| `Super + Shift + S` | Screenshot region (interactive) |
| `Super + Print` | Screenshot full screen |
| `Super + Alt + S` | Screenshot active window |

### Clipboard & Utilities

| Keybind | Action |
|---------|--------|
| `Super + V` | Clipboard history (cliphist) |
| `Super + Period` | Emoji picker |
| `Super + Shift + C` | Color picker (hyprpicker) |

### System Controls

| Keybind | Action |
|---------|--------|
| `Super + L` | Lock screen (hyprlock) |
| `Super + Escape` | Power menu (wlogout) |
| `Super + Shift + Q` | Quit Hyprland |
| `Super + Shift + R` | Reload Hyprland config |

---

## Media Controls

### Audio

| Keybind | Action |
|---------|--------|
| `XF86AudioRaiseVolume` | Increase volume |
| `XF86AudioLowerVolume` | Decrease volume |
| `XF86AudioMute` | Toggle mute |
| `Shift + XF86AudioRaiseVolume` | Increase volume (smaller steps) |
| `Shift + XF86AudioLowerVolume` | Decrease volume (smaller steps) |

### Media Playback

| Keybind | Action |
|---------|--------|
| `XF86AudioPlay` | Play/Pause |
| `XF86AudioPause` | Pause |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |

### Brightness

| Keybind | Action |
|---------|--------|
| `XF86MonBrightnessUp` | Increase brightness |
| `XF86MonBrightnessDown` | Decrease brightness |

---

## Special Functions

### Hyprland Features

| Keybind | Action |
|---------|--------|
| `Super + Z` | Toggle zoom (magnifier) |
| `Super + Mouse Scroll` | Adjust zoom level |
| `Super + G` | Toggle gaps |
| `Super + B` | Toggle waybar visibility |

### Window Groups/Tabs

| Keybind | Action |
|---------|--------|
| `Super + T` | Toggle window group (tab) |
| `Super + Alt + Left` | Focus previous tab |
| `Super + Alt + Right` | Focus next tab |

---

## Hyprland Dispatcher Commands

These can be executed via `hyprctl dispatch <command>`

### Useful Dispatchers

```bash
# Move window to a specific workspace
hyprctl dispatch movetoworkspace 5

# Toggle floating
hyprctl dispatch togglefloating

# Center window
hyprctl dispatch centerwindow

# Fullscreen different modes
hyprctl dispatch fullscreen 0  # Fullscreen (keep gaps)
hyprctl dispatch fullscreen 1  # Maximize (no gaps)
hyprctl dispatch fullscreen 2  # Fullscreen (fake, per window)

# Reload config
hyprctl reload

# List all windows
hyprctl clients

# List all workspaces
hyprctl workspaces
```

---

## Modifying Keybindings

### Custom Keybinds

Edit your custom keybinds:
```bash
nano ~/.config/hypr/custom/keybinds.conf
```

### Default Keybinds

View/edit default keybinds (not recommended):
```bash
nano ~/.config/hypr/hyprland/keybinds.conf
```

### Reload Configuration

After editing, reload Hyprland:
```bash
hyprctl reload
```

Or use: `Super + Shift + R`

---

## Tips & Tricks

### Finding Window Classes

To find the class of a window for creating rules:
```bash
hyprctl clients | grep class
```

### Testing Keybinds

Test a keybind without editing configs:
```bash
hyprctl dispatch exec kitty
```

### Unbinding Keys

To unbind a key in custom keybinds:
```
unbind = SUPER, KEY
```

---

## Additional Resources

- **Hyprland Wiki:** https://wiki.hyprland.org/
- **Keybind Syntax:** https://wiki.hyprland.org/Configuring/Binds/
- **Dispatchers:** https://wiki.hyprland.org/Configuring/Dispatchers/

---

**Last Updated:** 2025-10-29
