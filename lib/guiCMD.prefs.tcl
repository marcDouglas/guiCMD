
    proc guiCMD_prefs_initialize {} {
        global homeDir availScreens sourcedScreens
        
        set homeDir [pwd]
        set sourcedScreens [list]
        
        set availScreens [screenM_find]     
        foreach item $availScreens {
                addDynamicMenuButtons $item
        }        
          
        readPrefFile
        setupUserPrefs

    }    
       
    proc setupUserPrefs {} {
        global openScreens availScreens sourcedScreens
         foreach aScreen $openScreens {
               if { [ lsearch $availScreens $aScreen ] != -1 } {
                    readScreenSource $aScreen
                    #lappend sourcedScreens $aScreen
                    screenM_create $aScreen
              }
        }   
    }  
    
    proc addDynamicMenuButtons { aScreen } {
            global bRow bCol
            set newButton ".f.screenButtons."
            append newButton $aScreen
            button $newButton -text $aScreen -command "screenM_requested $aScreen"
            grid $newButton -column $bCol -row $bRow
            incr bCol 1
            
            .menubar.screens add command -label "$aScreen" \
                  -underline 0 \
                  -command "screenM_requested $aScreen"       
    }

    proc readPrefFile {} {
            global homeDir openScreens
            file mkdir ~/.config/guiCMD/
            cd ~/.config/guiCMD/
            if { [ file exists guiCMD.config ] == 1 } { 
                    set fp [open guiCMD.config r]
                    set openScreens [read $fp]
                    close $fp
                    cd $homeDir

            } else {
                cd $homeDir
                set openScreens [list]      
            }
            
    }
    
    proc writePrefFile {} {
        global homeDir openScreens
        file mkdir ~/.config/guiCMD/
        cd ~/.config/guiCMD/
        set fp [open guiCMD.config w]
        puts $fp $openScreens
        close $fp   
        cd $homeDir
    }

  
    proc readScreenSource { aScreen } {
        global sourcedScreens homeDir
        puts "sourcedScreens: $sourcedScreens"
        if { [ lsearch $sourcedScreens $aScreen ] == -1 } {
                cd $homeDir
                set preFix "screens/"
                set postFix ".gui.tcl"
                set slash "/"
                set sourceFile $preFix$aScreen$slash$aScreen$postFix
                puts "readingSource:$sourceFile"    
                source  $sourceFile
                
                lappend sourcedScreens $aScreen
        }

    }
    

