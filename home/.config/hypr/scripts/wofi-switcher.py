#!/usr/bin/env python3
import subprocess
import json
import sys
import os

def check_toggle():
    """If wofi is running, kill it and exit to act as a toggle."""
    result = subprocess.run(['pkill', '-x', 'wofi'], stderr=subprocess.DEVNULL)
    if result.returncode == 0:
        sys.exit(0)

def get_windows():
    """Fetches windows and maps icons with strict priority matching."""
    try:
        output = subprocess.check_output(['/usr/bin/hyprctl', 'clients', '-j'], encoding='utf-8')
        clients = json.loads(output)
    except Exception:
        return {}

    window_map = {}
    
    # Priority icon names (exact matches for your apps)
    priority_map = {
        'code': ['com.visualstudio.code', 'vscode', 'code-oss'],
        'thunar': ['thunar', 'org.xfce.thunar']
    }

    search_dirs = [
        '/usr/share/icons/hicolor/scalable/apps',
        '/usr/share/icons/hicolor/48x48/apps',
        '/usr/share/pixmaps'
    ]

    for w in [c for c in clients if c.get('mapped') and c.get('class')]:
        w_class = w['class'].lower()
        w_title = w['title'].replace('\n', ' ')[:65]
        
        icon_path = ""
        # 1. Check priority map for exact icon names
        names_to_try = priority_map.get(w_class, [w_class])
        
        for name in names_to_try:
            for d in search_dirs:
                if os.path.exists(d):
                    # Check for exact file match first
                    for ext in ['.png', '.svg']:
                        target = os.path.join(d, name + ext)
                        if os.path.exists(target):
                            icon_path = target
                            break
                if icon_path: break
            if icon_path: break

        # 2. Fallback to fuzzy match only if priority check fails
        if not icon_path:
            for d in search_dirs:
                if os.path.exists(d):
                    for f in os.listdir(d):
                        if w_class in f.lower() and (f.endswith('.png') or f.endswith('.svg')):
                            icon_path = os.path.join(d, f)
                            break
                if icon_path: break

        label = f"{w['class']} - {w_title}"
        if label in window_map:
            count = 1
            while f"{label} ({count})" in window_map: count += 1
            label = f"{label} ({count})"
            
# Map icon-formatted label to raw address
        if icon_path:
            # Added a space here: 'text: ' + label
            window_map[f"img:{icon_path}:text: {label}"] = w['address']
        else:
            window_map[label] = w['address']
            
    return window_map

def wofi(options):
    """Pipes options to wofi and returns the selection."""
    try:
        return subprocess.check_output(
            ['wofi', '--show', 'dmenu', '--allow-images', 
             '--style', os.path.expanduser('~/.config/wofi/style-switcher.css'),
             '--prompt', 'Windows', '--location', 'bottom', 
             '--yoffset', '0', '--cache-file', '/dev/null'],
            input='\n'.join(options),
            encoding='utf-8',
            stderr=subprocess.DEVNULL
        ).strip()
    except subprocess.CalledProcessError:
        return None

def focus_window(address):
    """Brute-forces the wrapper's API to ensure the window successfully focuses."""
    strategies = [
        ['/usr/bin/hyprctl', '--batch', f'dispatch focuswindow address:{address}'],
        ['/usr/bin/hyprctl', 'dispatch', f'hl.dsp.native("focuswindow", "address:{address}")'],
        ['/usr/bin/hyprctl', 'dispatch', f'hl.dsp.focus({{window="address:{address}"}})'],
        ['/usr/bin/hyprctl', 'dispatch', f'hl.dsp.focus({{address="{address}"}})'],
        ['/usr/bin/hyprctl', 'dispatch', f'hl.dsp.window.focus("address:{address}")']
    ]

    for cmd in strategies:
        try:
            res = subprocess.run(cmd, capture_output=True, text=True)
            if "error:" not in res.stdout.lower() and "exception" not in res.stdout.lower():
                return True
        except Exception:
            continue
    return False

def main():
    check_toggle()
    window_map = get_windows()
    if not window_map:
        sys.exit(0)
        
    selected = wofi(list(window_map.keys()))
    
    if selected and selected in window_map:
        focus_window(window_map[selected])

if __name__ == '__main__':
    main()