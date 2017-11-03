#!/usr/bin/wish

    package require Tk
    tk appname "guiCommander"
    
    source guiCommander.menu.tcl
    source guiCommander.prefsManager.tcl
    
    source screens/wmctrl/wmctrl.root.tcl
    #source screens/wmctrl.dataobjects.tcl
    #source screens/wmctrl.filterList13.tcl
    #source screens/wmctrl.gui.tcl
    #source screens/wmctrl.parse.tcl
        
    source screens/newFunction.gui.tcl
    
    #load default screen
    proc dummyproc {} {
        destroy .h
    }

   #frame .f
    #wmctrl_initialize .f
 
    frame .g
    grid .g -column 0 -row 0
    
    button .g.g1 -text "wmctrl" -command wmctrl_requested
    button .g.g2 -text "newFuction" -command newFunction_requested   
    grid .g.g1 -column 0 -row 0 
    grid .g.g2 -column 1 -row 0
    
    guiPrefs_read



