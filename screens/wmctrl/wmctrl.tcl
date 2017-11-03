#!/usr/bin/tclsh

#default action
global action numButCol
set action "-lp"
set numButCol 3

proc self_initialize {} {
      
        frame .f
        grid .f -column 0 -row 0
      #  puts "self_initialize :wmctrl"

        frame .f.wmctrl -borderwidth 5 -relief sunken
        grid .f.wmctrl -column 0 -row 0
        wmctrl_initialize
}

proc ifSolo {} {
    global wmctrl
    if [info exists wmctrl] {
        # source wmctrl.gui.tcl
    } else {
        set wmctrl "/usr/bin/wmctrl"
       # source wmctrl.gui.tcl
        if { [ file exists wmctrl.gui.tcl ] == 1 } {
            source wmctrl.gui.tcl
        } else {
            cd screens/wmctrl
            if { [ file exists wmctrl.gui.tcl ] == 1 } {
                source wmctrl.gui.tcl
            } else {
                    puts "error cannot find self (wmctrl folder)"
                    return
            }
        }
        self_initialize
    }
}

ifSolo
