proc guiPrefs_refresh {} {
    global guiPrefs 
    .f.top.rightw.filterListbox delete 0 end
    foreach filter $guiPrefs {
        .f.top.rightw.filterListbox insert end $filter
    }

}
proc guiPrefs_write {} {
    global guiPrefs
    file mkdir ~/.config/guiCommander/
    cd ~/.config/guiCommander/
    set fp [open guiCommander.config w]
    puts $fp $guiPrefs
    close $fp   
}

proc guiPrefs_read {} {
        global guiPrefs
        file mkdir ~/.config/guiCommander/
        cd ~/.config/guiCommander/
        if { [ file exists guiCommander.config ] == 1 } { 
                set fp [open guiCommander.config r]
                set guiPrefs [read $fp]
                close $fp
                guiPrefs_inialize
        } else {
            set guiPrefs [list]      
        }
}

proc guiPrefs_inialize {} {
    global guiPrefs
     foreach screen $guiPrefs {
            switch $screen {
                "wmctrl" { wmctrl_create }
                "newFunction" { newFunction_create }
            }
    }   
}

proc guiPrefs_add {} {
        set tempNewFilter [.f.top.rightw.filter get]
        if { $tempNewFilter != "" } {
            global guiPrefs
            if  { [ lsearch $guiPrefs $tempNewFilter ] == -1 } {
                #puts "new filter ($tempNewFilter) is being added"
                lappend guiPrefs $tempNewFilter
                guiPrefs_write
                .f.top.rightw.filterListbox insert end $tempNewFilter
            } else {
                puts "filter ($tempNewFilter) was rejected. (duplicate)"
            }
        }
}

proc guiPrefs_remove {} {
    global guiPrefs
    set tempIndex [.f.top.rightw.filterListbox curselection]
    #puts [.f.top.rightw.filterListbox curselection]
    foreach aIndex $tempIndex {
            #puts "aIndex $aIndex"
            .f.top.rightw.filterListbox delete $aIndex
            set guiPrefs [lreplace $guiPrefs $aIndex $aIndex]
            guiPrefs_write
            #[ lsearch $guiPrefs $tempNewFilter ]
    }
}
