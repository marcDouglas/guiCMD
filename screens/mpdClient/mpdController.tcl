#!/usr/bin/tclsh
package require Tk

#default action
global action numButCol
set action "-lp"
set numButCol 3

proc self_initialize {} {
      
        frame .f
    grid .f -column 0 -row 0
  #  puts "self_initialize :mpdController"

    frame .f.mpdController -borderwidth 5 -relief sunken
    grid .f.mpdController -column 0 -row 0
    mpdController_initialize
}

proc ifSolo {} {
    if { [ file exists mpdController.gui.tcl ] == 1 } {
        source mpdController.gui.tcl
    } else {
        cd screens/mpdController
        if { [ file exists mpdController.gui.tcl ] == 1 } {
            source mpdController.gui.tcl
        } else {
                puts "error cannot find self (mpdController folder)"
                return
        }
    }
    self_initialize
}


ifSolo
