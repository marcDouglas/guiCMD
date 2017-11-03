#xinput.filterList
global xinput_pref_folder
set xinput_pref_folder "~/.config/guiCMD/screens/xinput"

proc xinputFilter_value { } {
        global xinputFilter
        if { ! [info exists xinputFilter] } {
             xinputFilter_read
            
        }
        return [lindex $xinputFilter 0]
}

proc xinputFilter_setValue { x } {
        global xinputFilter
        set xinputFilter [list $x]
}

proc xinputFilter_length {} {
        global xinputFilter
        return [llength $xinputFilter]
}

proc xinputFilter_write {} {
    global xinputFilter xinput_pref_folder
    writeObjectToFile xinputFilter $xinput_pref_folder $xinputFilter
}

proc xinputFilter_read {} {
        global xinputFilter xinput_pref_folder
        set xinputFilter [readFileFromFolder xinputFilter $xinput_pref_folder]
}

