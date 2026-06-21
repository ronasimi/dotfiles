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
    """Fetches windows, sorts by workspace, and creates a map with icon-formatting."""
    try:
        output = subprocess.check_output(['/usr/bin/hyprctl', 'clients', '-j'], encoding='utf-8')
        clients = json.loads(output)
    except Exception:
        return []

    # Sort clients by workspace ID
    sorted_clients = sorted([c for c in clients if c.get('mapped') and c.get('class')], 
                            key=lambda x: x['workspace']['id'])

    windows_list = []
    current_ws = -1
    
    priority_map = {
        'code': ['com.visualstudio.code', 'vscode', 'code-oss'],
        'thunar': ['thunar', 'org.xfce.thunar']
    }

    search_dirs = [
        '/usr/share/icons/hicolor/scalable/apps',
        '/usr/share/icons/hicolor/48x48/apps',
        '/usr/share/pixmaps'
    ]

    for w in sorted_clients:
        ws_id = w['workspace']['id']
        if ws_id != current_ws:
            # Clean header label (No dashes)
            windows_list.append((f"Workspace {ws_id}", None))
            current_ws = ws_id

        w_class = w['class'].lower()
        w_title = w['title'].replace('\n', ' ')[:65]
        
        # Icon Lookup
        icon_path = ""
        names_to_try = priority_map.get(w_class, [w_class])
        for name in names_to_try:
            for d in search_dirs:
                if os.path.exists(d):
                    for ext in ['.png', '.svg']:
                        target = os.path.join(d, name + ext)
                        if os.path.exists(target): icon_path = target; break
                if icon_path: break
            if icon_path: break

        # Fuzzy Fallback
        if not icon_path:
            for d in search_dirs:
                if os.path.exists(d):
                    for f in os.listdir(d):
                        if w_class in f.lower() and (f.endswith('.png') or f.endswith('.svg')):
                            icon_path = os.path.join(d, f)
                            break
                if icon_path: break

        label = f"{w['class']} - {w_title}"
        display_label = f"img:{icon_path}:text: {label}" if icon_path else label
        
        windows_list.append((display_label, w['address']))
            
    return windows_list

def wofi(labels):
    """Pipes labels to wofi."""
    try:
        return subprocess.check_output(
            ['wofi', '--show', 'dmenu', '--allow-images', 
             '--style', os.path.expanduser('~/.config/wofi/style-switcher.css'),
             '--prompt', 'Windows', '--location', 'bottom', 
             '--yoffset', '0', '--cache-file', '/dev/null'],
            input='\n'.join(labels),
            encoding='utf-8',
            stderr=subprocess.DEVNULL
        ).strip()
    except subprocess.CalledProcessError:
        return None

def focus_window(address):
    """Focuses window using the best available strategy."""
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
    windows_data = get_windows()
    if not windows_data:
        sys.exit(0)
        
    labels = [item[0] for item in windows_data]
    selected = wofi(labels)
    
    if selected:
        for label, address in windows_data:
            if label == selected and address is not None:
                focus_window(address)
                break

if __name__ == '__main__':
    main()