# X configurations


## Xresources Troubleshooting
In case `Xresources` is not loaded properly on startup, you should check if the
command `xrdb -merge ~/.Xresources` is ran somewhere (display managers usually
run this by default).

* On Ubuntu 18.04, GDM loads `Xresources` using the `-nocpp` flag, which ignores
  `#include` directives. Remove the flag from the file `/etc/gdm3/Xsession`.
* You must have a preprocessor (such as `gcc` or `g++` to use `#include`
  directives. Make sure you have a preprocessor installed (`build-essentials`)
