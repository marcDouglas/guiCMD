#!/usr/bin/tclsh
package require Tk

#default action
global action numButCol
set action "-lp"
set numButCol 3

proc self_initialize {} {
      
        frame .f
    grid .f -column 0 -row 0
  #  puts "self_initialize :syncDrives"

    frame .f.syncDrives -borderwidth 5 -relief sunken
    grid .f.syncDrives -column 0 -row 0
    syncDrives_initialize
}

proc ifSolo {} {
    if { [ file exists syncDrives.gui.tcl ] == 1 } {
        source syncDrives.gui.tcl
    } else {
        cd screens/syncDrives
        if { [ file exists syncDrives.gui.tcl ] == 1 } {
            source syncDrives.gui.tcl
        } else {
                puts "error cannot find self (syncDrives folder)"
                return
        }
    }
    self_initialize
}


ifSolo
