#!/bin/bash
# Default acpi script that takes an entry for all actions

# Function to get current environment
pid=$(pgrep -t tty$(fgconsole) xinit)
pid=$(pgrep -P $pid -n)

import_environment() {
        (( pid )) && for var; do
                IFS='=' read key val < <(egrep -z "$var" /proc/$pid/environ)

                printf -v "$key" %s "$val"
                [[ ${!key} ]] && export "$key"
        done
}
import_environment XAUTHORITY USER DISPLAY

case "$1" in
  button/power)
    case "$2" in
      PBTN|PWRF)
        logger 'PowerButton pressed'
        ;;
      *)
        logger "ACPI action undefined: $2"
        ;;
    esac
    ;;
  button/sleep)
    case "$2" in
      SLPB|SBTN)
        logger 'SleepButton pressed'
        ;;
      *)
        logger "ACPI action undefined: $2"
        ;;
    esac
    ;;
  ac_adapter)
    case "$2" in
      AC|ACAD|ADP0)
        case "$4" in
          00000000)
            logger 'AC unplugged'
            ;;
          00000001)
            logger 'AC plugged'
            ;;
        esac
        ;;
      *)
        logger "ACPI action undefined: $2"
        ;;
    esac
    ;;
  battery)
    case "$2" in
      BAT0)
        case "$4" in
          00000000)
            logger 'Battery online'
            ;;
          00000001)
            logger 'Battery offline'
            ;;
        esac
        ;;
      CPU0)
        ;;
      *)  logger "ACPI action undefined: $2" ;;
    esac
    ;;
  button/lid)
    case "$3" in
      close)
        logger 'LID closed'

        # Closed on Battery (suspend)
        acpi -a | grep -q "off-line"
        if [ $? = 0 ] ; then
          systemctl suspend
	# Ignore if external display connected
	elif [ "$(xrandr -q | grep ' connected' | wc -l)" != "1" ] ; then
	  logger 'LID closed, External display connected'
        # Otherwise lock screen
        else
	   sudo -u `ps -o ruser= -C xinit` xset s activate
        fi
        ;;
      open)
        logger 'LID opened'
        # Force monitor on
        sudo -u `ps -o ruser= -C xinit` xset dpms force on
        ;;
      *)
        logger "ACPI action undefined: $3"
        ;;
    esac
    ;;
  *)
    logger "ACPI group/action undefined: $1 / $2"
    ;;
esac

# vim:set ts=4 sw=4 ft=sh et:
