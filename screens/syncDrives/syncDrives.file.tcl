global syncDrives_pref_folder
set syncDrives_pref_folder "~/.config/guiCMD/screens/syncDrives/"


proc syncDrives_backupLocations_refresh {} {
    global backupLocations 
    .f.syncDrives.top.rightw.filterFrame.backupLocationsbox delete 0 end
    foreach filter $backupLocations {
        .f.syncDrives.top.rightw.filterFrame.backupLocationsbox insert end $filter
    }
    syncDrives_refreshWindows
}
proc syncDrives_backupLocations_write {} {
    global backupLocations syncDrives_pref_folder
    #writeObjectToFile { varName preferenceFolder theVariable }
    writeObjectToFile backupLocations $syncDrives_pref_folder $backupLocations
       # puts "write:backupLocations:$backupLocations"
}



proc syncDrives_backupLocations_read {} {
        global backupLocations syncDrives_pref_folder
        set backupLocations [readFileFromFolder backupLocations $syncDrives_pref_folder]
        #puts "read:backupLocations:$backupLocations"
}

proc syncDrives_backupLocations_add {} {
        set tempNewFilter [.f.syncDrives.top.rightw.filterFrame.filter get]
        if { $tempNewFilter != "" } {
            global backupLocations
            if  { [ lsearch $backupLocations $tempNewFilter ] == -1 } {
                #puts "new filter ($tempNewFilter) is being added"
                lappend backupLocations $tempNewFilter
                syncDrives_backupLocations_write
                .f.syncDrives.top.rightw.filterFrame.backupLocationsbox insert end $tempNewFilter
                syncDrives_backupLocations_refresh
            } else {
                puts "filter ($tempNewFilter) was rejected. (duplicate)"
            }
        }
}

proc syncDrives_backupLocations_remove {} {
    global backupLocations
    set tempIndex [.f.syncDrives.top.rightw.filterFrame.backupLocationsbox curselection]
    #puts [.f.syncDrives.top.rightw.filterFrame.backupLocationsbox curselection]
    foreach aIndex $tempIndex {
            #puts "aIndex $aIndex"
            .f.syncDrives.top.rightw.filterFrame.backupLocationsbox delete $aIndex
            set backupLocations [lreplace $backupLocations $aIndex $aIndex]
            syncDrives_backupLocations_write
            #[ lsearch $backupLocations $tempNewFilter ]
            syncDrives_backupLocations_refresh
    }
}

proc syncDrives_numColumnPrefs_write {} {
    global numButCol syncDrives_pref_folder
    file mkdir $syncDrives_pref_folder
    cd $syncDrives_pref_folder
    set fp [open backupLocations.txt w]
    puts $fp $backupLocations
    close $fp   
}

proc syncDrives_numColumnPrefs_read {} {
        global numButCol syncDrives_pref_folder
        file mkdir $syncDrives_pref_folder
        cd $syncDrives_pref_folder
        if { [ file exists numButCol.txt ] == 1 } { 
                set fp [open numButCol.txt r]
                set numButCol [read $fp]
                close $fp
        } else {
            set numButCol [list]      
        }
}


