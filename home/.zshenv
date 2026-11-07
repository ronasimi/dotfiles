typeset -U PATH path

# Available to login, interactive, and non-interactive shells (including desktop launchers).
path=("$HOME/.pi/agent/bin" "$HOME/.local/bin" "$HOME/.bin" $path)
export PATH

# Pin durable-subagents to the stable managed launcher, independent of PATH.
export DSA_PI_BIN=/home/ron/.pi/agent/bin/pi

# Set VAAPI driver
#export LIBVA_DRIVER_NAME=iHD
