#
#   ____                      _
#  / ___|___  _ __ ___  _ __ | |_ ___  _ __
# | |   / _ \| '_ ` _ \| '_ \| __/ _ \| '_ \
# | |__| (_) | | | | | | |_) | || (_) | | | |
#  \____\___/|_| |_| |_| .__/ \__\___/|_| |_|
#                      |_|
#

# Daemonize
daemon = true;

##########################
#
#   Backend
#
##########################
backend = "glx"
glx-no-stencil = true;
glx-swap-method  = 1;
glx-no-rebind-pixmap = true;
xrender-sync-fence = true;

##########################
#
#   Miscellaneous
#
##########################
#mark-ovredir-focused needs to be false for bspwm
mark-ovredir-focused = true;
focus-exclude = [
	"class_g= 'i3-frame'",
	"name *?= 'i3lock'",
	"class_g= 'Gimp'",
	"class_g= 'mpv'",
	"class_g= 'Dmenu'",
	"class_g= 'Gimp-2.10'",
	"class_g= 'I3-exit'"
];
use-ewmh-active-win = true;
vsync= "opengl-swc";
paint-on-overlay = true;
unredir-if-possible = true;

##########################
#
#   Blur
#
##########################
blur-background = true;
blur-method = "kawase";
blur-strength = 10;
blur-kern = "3x3box";
blur-background-frame = false;
blur-background-fixed = false;
blur-background-exclude = [
	"window_type = 'dock'",
	"window_type = 'desktop'",
	"_GTK_FRAME_EXTENTS@:c",
	"class_g = 'i3-frame'",
	"class_g = 'Dmenu'",
	"class_g = 'slop'"
];

##########################
#
#   Opacity
#
##########################
inactive-opacity = 0.75;
inactive-opacity-override = false;
alpha-step = 0.05;
opacity-rule = [
	"99:class_g = 'i3-frame'",
	"99:class_g = 'Dmenu'",
	"99:class_g = 'mpv'"
];

##########################
#
#   Fading
#
##########################
fading = true;
fade-delta = 10;
fade-in-step = 0.05;
fade-out-step = 0.05;
fade-exclude = [
	"class_g = 'i3-frame'",
	"class_g = 'Dmenu'",
	"class_g = 'mpv'"
];

##########################
#
#   Shadows
#
##########################
shadow = true;
no-dnd-shadow = false;
no-dock-shadow = true;
clear-shadow = true;
shadow-radius = 8;
shadow-offset-x = -8;
shadow-offset-y = -8;
shadow-exclude = [
	"name = 'Notification'",
	"class_g = 'Conky'",
	"class_g = 'Dmenu'",
	"class_g = 'slop'",
	"_GTK_FRAME_EXTENTS@:c",
	"class_g = 'mpv'",
	"class_g = 'I3-exit'",
	"!focused"
];

##########################
#
#   Dim
#
##########################
inactive-dim = 0.25;
inactive-dim-fixed = false;

##########################
#
#   Window type settings
#
##########################
wintypes:
{
  tooltip = { fade = true; shadow = true; opacity = 0.75; focus = true; };
  menu = { fade= false; shadow = false; focus = true; };
};
