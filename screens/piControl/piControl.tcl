#!/usr/bin/tclsh
package require Tk

#default action
global action numButCol
set action "-lp"
set numButCol 3

proc self_initialize {} {
      
        frame .f
    grid .f -column 0 -row 0
  #  puts "self_initialize :piControl"

    frame .f.piControl -borderwidth 5 -relief sunken
    grid .f.piControl -column 0 -row 0
    piControl_initialize
}

proc ifSolo {} {
    if { [ file exists piControl.gui.tcl ] == 1 } {
        source piControl.gui.tcl
    } else {
        cd screens/piControl
        if { [ file exists piControl.gui.tcl ] == 1 } {
            source piControl.gui.tcl
        } else {
                puts "error cannot find self (piControl folder)"
                return
        }
    }
    self_initialize
}


ifSolo
