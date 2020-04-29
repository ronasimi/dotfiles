#!/usr/bin/env python3
import i3ipc
import sys

i3 = i3ipc.Connection()
splitv_text = 'LAYV'
splith_text = 'LAYH'
tabbed_text = 'LAYT'
stacked_text = 'LAYS'

parent = i3.get_tree().find_focused().parent
if parent.layout == 'splitv':
	print(splitv_text)
	sys.stdout.flush()
elif parent.layout == 'splith':
	print(splith_text)
	sys.stdout.flush()
elif parent.layout == 'tabbed':
	print(tabbed_text)
	sys.stdout.flush()
elif parent.layout == 'stacked':
	print(stacked_text)
	sys.stdout.flush()

def on_event(self, _):
	parent = i3.get_tree().find_focused().parent
	if parent.layout == 'splitv':
		print(splitv_text)
		sys.stdout.flush()
	elif parent.layout == 'splith':
		print(splith_text)
		sys.stdout.flush()
	elif parent.layout == 'tabbed':
		print(tabbed_text)
		sys.stdout.flush()
	elif parent.layout == 'stacked':
		print(stacked_text)
		sys.stdout.flush()


# Subscribe to events
i3.on("window::focus", on_event)
i3.on("binding", on_event)

# Start the main loop and wait for events to come in.
i3.main()
