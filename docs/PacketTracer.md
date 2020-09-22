# Packet Tracer

Packet Tracer is a program written with Qt, which will use your system theme for its UI. However, it is poorly designed and the usage of a dark theme results in unreadable text.

Since this is a Qt application, the `GTK_THEME` envvar isn't applicable.

The `QT_STYLE_OVERRIDE` envvar, as well as the `-style` argument can be used to set the style. On my system, I have `Fusion` and `Windows` - the Qt defaults - as well as `Breeze`. I'm able to change these, but these do not affect the colors used.

I'm not sure what the `QT_QPA_PLATFORMTHEME` envvar is meant for, but it doesn't seem to help here.

Changing the system-wide colors to Breeze-Light results in PT using the light colors, but it's unclear to me how to only use light colors for PT. I think it doesn't help that PT bundles its own Qt libraries, so the `~/.config/*rc` configuration files are not used.

What I did find to work, though, was forcing PT to use a different XDG configuration directory as recommended here (https://forum.kde.org/viewtopic.php?f=17&t=136316). This command works to launch PT with a different config directory, which for me had a light theme by default:
```bash
env XDG_CONFIG_HOME=~/.local/share/pthome /opt/packettracer/packettracer
```
