#!/usr/bin/tclsh

package require Tk
#package require tooltip

global conkyArray
global matchList
global autoApply

#set conkyArray [array]
set autoApply no

set matchList [list background use_xft xftfont xftalpha update_interval total_run_times own_window own_window_transparent own_window_type own_window_argb_visual own_window_hints double_buffer minimum_size maximum_width draw_shades draw_outline draw_borders draw_graph_borders default_color default_shade_color default_outline_color alignment gap_x gap_y no_buffers uppercase cpu_avg_samples override_utf8_locale]
        
    
    proc autoApply {} {
            global autoApply
            if $autoApply {
                set autoApply no
            } else {
                set autoApply yes
                conkyWriteChanges
            }
    }
        
    proc checkAutoApply {} {
        global autoApply
        if { $autoApply } {
            conkyWriteChanges }
    }
    

proc changeWindowHints { witch } {
    global conkyArray
    set lilSplit [split $conkyArray(own_window_hints) ","]
    set index [lsearch $lilSplit $witch]
    if { $index == -1 } {
        lappend lilSplit $witch
    } else {
        set lilSplit [lreplace $lilSplit $index $index]
    }
    set conkyArray(own_window_hints) [join $lilSplit ","]
    
    checkAutoApply
    #putsArray
        

}

proc changeColor { witch } {
     global conkyArray       
    
        set color [tk_chooseColor -title "Choose a $witch" -parent .f.conky.notebook.f1\
	-initialcolor "#$conkyArray($witch)"]
        set color [string range $color 1 end]
        set conkyArray($witch) $color
        
        checkAutoApply
        
}

proc putsArray {} {
         global conkyArray
         foreach {keys item} [array get conkyArray] {
            puts "$keys $item"
        }   
    
}

proc changeFont {} {
    
    
    checkAutoApply
}

#########################################################
proc conky_self_initialize {} {
        frame .f
        grid .f -column 0 -row 0
      #  puts "self_initialize :wmctrl"

        frame .f.conky -borderwidth 5 -relief sunken
        grid .f.conky -column 0 -row 0

        conky_initialize
        #startconky
}

proc ifSolo {} {
    global rawConky
    if [info exists rawConky] {
        #startconky
    } else {
        set rawConky 1
        if { [ file exists conky.gui.tcl ] == 1 } {
            source conky.gui.tcl
        } else {
            cd screens/conky
            if { [ file exists conky.gui.tcl ] == 1 } {
                source conky.gui.tcl
            } else {
                    puts "error cannot find self (conky folder)"
                    return
            }
        }
        conky_self_initialize
    }
}

ifSolo
###########################################################
 
