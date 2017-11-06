global mpdController_pref_folder
set mpdController_pref_folder "~/.config/guiCMD/screens/mpdController/"


proc mpdController_backupLocations_refresh {} {
    global backupLocations 
    .f.mpdController.top.rightw.filterFrame.backupLocationsbox delete 0 end
    foreach filter $backupLocations {
        .f.mpdController.top.rightw.filterFrame.backupLocationsbox insert end $filter
    }
    mpdController_refreshWindows
}
proc mpdController_backupLocations_write {} {
    global backupLocations mpdController_pref_folder
    #writeObjectToFile { varName preferenceFolder theVariable }
    writeObjectToFile backupLocations $mpdController_pref_folder $backupLocations
       # puts "write:backupLocations:$backupLocations"
}



proc mpdController_backupLocations_read {} {
        global backupLocations mpdController_pref_folder
        set backupLocations [readFileFromFolder backupLocations $mpdController_pref_folder]
        #puts "read:backupLocations:$backupLocations"
}

proc mpdController_backupLocations_add {} {
        set tempNewFilter [.f.mpdController.top.rightw.filterFrame.filter get]
        if { $tempNewFilter != "" } {
            global backupLocations
            if  { [ lsearch $backupLocations $tempNewFilter ] == -1 } {
                #puts "new filter ($tempNewFilter) is being added"
                lappend backupLocations $tempNewFilter
                mpdController_backupLocations_write
                .f.mpdController.top.rightw.filterFrame.backupLocationsbox insert end $tempNewFilter
                mpdController_backupLocations_refresh
            } else {
                puts "filter ($tempNewFilter) was rejected. (duplicate)"
            }
        }
}

proc mpdController_backupLocations_remove {} {
    global backupLocations
    set tempIndex [.f.mpdController.top.rightw.filterFrame.backupLocationsbox curselection]
    #puts [.f.mpdController.top.rightw.filterFrame.backupLocationsbox curselection]
    foreach aIndex $tempIndex {
            #puts "aIndex $aIndex"
            .f.mpdController.top.rightw.filterFrame.backupLocationsbox delete $aIndex
            set backupLocations [lreplace $backupLocations $aIndex $aIndex]
            mpdController_backupLocations_write
            #[ lsearch $backupLocations $tempNewFilter ]
            mpdController_backupLocations_refresh
    }
}

proc mpdController_numColumnPrefs_write {} {
    global numButCol mpdController_pref_folder
    file mkdir $mpdController_pref_folder
    cd $mpdController_pref_folder
    set fp [open backupLocations.txt w]
    puts $fp $backupLocations
    close $fp   
}

proc mpdController_numColumnPrefs_read {} {
        global numButCol mpdController_pref_folder
        file mkdir $mpdController_pref_folder
        cd $mpdController_pref_folder
        if { [ file exists numButCol.txt ] == 1 } { 
                set fp [open numButCol.txt r]
                set numButCol [read $fp]
                close $fp
        } else {
            set numButCol [list]      
        }
}


