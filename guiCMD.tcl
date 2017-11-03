#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

    package require Tk
    tk appname "guiCMD"
    
    source lib/guiCMD.menu.tcl
    source lib/guiCMD.prefs.tcl
    source lib/guiCMD.screenM.tcl
    
   # source screens/wmctrl/wmctrl.gui.tcl
   # source screens/newFunction/newFunction.gui.tcl
 
    screenM_initialize
 
    guiCMD_prefs_initialize

