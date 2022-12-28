.SUFFIXES:

SHELL	:= /bin/sh

config/xorg.xkb:
	setxkbmap \
		-layout "us,us" \
		-variant ",dvp" \
		-option "grp:sclk_toggle,compose:lctrl,ctrl:nocaps" \
		-print \
		> "$@"
