global wmctrl_pref_folder
set wmctrl_pref_folder "~/.config/guiCMD/screens/wmctrl/"


proc wmctrl_filterList_refresh {} {
    global filterList13 
    .f.wmctrl.top.rightw.filterFrame.filterListbox delete 0 end
    foreach filter $filterList13 {
        .f.wmctrl.top.rightw.filterFrame.filterListbox insert end $filter
    }
    wmctrl_refreshWindows
}
proc wmctrl_filterList_write {} {
    global filterList13 wmctrl_pref_folder
    #writeObjectToFile { varName preferenceFolder theVariable }
    writeObjectToFile filterList13 $wmctrl_pref_folder $filterList13
       # puts "write:filterList13:$filterList13"
}



proc wmctrl_filterList_read {} {
        global filterList13 wmctrl_pref_folder
        set filterList13 [readFileFromFolder filterList13 $wmctrl_pref_folder]
        #puts "read:filterList13:$filterList13"
}

proc wmctrl_filterList_add {} {
        set tempNewFilter [.f.wmctrl.top.rightw.filterFrame.filter get]
        if { $tempNewFilter != "" } {
            global filterList13
            if  { [ lsearch $filterList13 $tempNewFilter ] == -1 } {
                #puts "new filter ($tempNewFilter) is being added"
                lappend filterList13 $tempNewFilter
                wmctrl_filterList_write
                .f.wmctrl.top.rightw.filterFrame.filterListbox insert end $tempNewFilter
                wmctrl_filterList_refresh
            } else {
                puts "filter ($tempNewFilter) was rejected. (duplicate)"
            }
        }
}

proc wmctrl_filterList_remove {} {
    global filterList13
    set tempIndex [.f.wmctrl.top.rightw.filterFrame.filterListbox curselection]
    #puts [.f.wmctrl.top.rightw.filterFrame.filterListbox curselection]
    foreach aIndex $tempIndex {
            #puts "aIndex $aIndex"
            .f.wmctrl.top.rightw.filterFrame.filterListbox delete $aIndex
            set filterList13 [lreplace $filterList13 $aIndex $aIndex]
            wmctrl_filterList_write
            #[ lsearch $filterList13 $tempNewFilter ]
            wmctrl_filterList_refresh
    }
}

proc wmctrl_numColumnPrefs_write {} {
    global numButCol wmctrl_pref_folder
    file mkdir $wmctrl_pref_folder
    cd $wmctrl_pref_folder
    set fp [open filterList13.txt w]
    puts $fp $filterList13
    close $fp   
}

proc wmctrl_numColumnPrefs_read {} {
        global numButCol wmctrl_pref_folder
        file mkdir $wmctrl_pref_folder
        cd $wmctrl_pref_folder
        if { [ file exists numButCol.txt ] == 1 } { 
                set fp [open numButCol.txt r]
                set numButCol [read $fp]
                close $fp
        } else {
            set numButCol [list]      
        }
}


