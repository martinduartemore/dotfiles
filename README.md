# dotfiles
My personal dotfiles


## Specifications
* Text editor: `vim`
* Shell: `bash`
* Terminal emulator: `urxvt`
* Terminal multiplexer: `tmux`


## Notes
* *vim*: Make sure to check your vim installation for X11 clipboard support
  (+clipboard & +xterm_clipboard).

* *Xresources not loading properly*: Some desktop managers (e.g., GNOME 3)
  include user-defined Xresources but use the flag `-nocpp`, which ignores
  `#include` commands. Fix for GDM3: remove the flag in `/etc/gdm3/Xsession`.
  [Source](
  https://manenko.com/2015/05/15/gdm-doesnt-load-included-files-from-xresources-in-arch-linux.html0)


## Dependencies
* xclip: copy&paste from terminal
* xmctrl: fullscreen toggle support
