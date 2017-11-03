source lib/guiCMD.screenM.find.tcl

proc screenM_initialize {} {
    global row mainFrame bCol bRow
    #set col 0
    set row 2
    set bCol 0
    set bRow 0
   # set mainFrame .f
    frame .f
    grid .f -column 0 -row 0
    frame .f.screenButtons
    grid .f.screenButtons -column 0 -row 0 -columnspan 2
    
}




proc screenM_requested { aScreen} {
     global openScreens mainFrame
     if { [ lsearch $openScreens $aScreen ] == -1 } {
            readScreenSource $aScreen
            screenM_create $aScreen 
            lappend openScreens $aScreen
            writePrefFile
     } else {
            screenM_release $aScreen 
     }
}

proc screenM_create { aScreen } {    
        #puts "screenM_create :$aScreen"
        global row

       set gridCol [expr ($row % 2)]
       set gridRow [expr ($row / 2)]
       #incr gridRow +1
       #puts "row #$row"
                  
        set screenFrame ".f."
        set screenFrame $screenFrame$aScreen
        
        frame $screenFrame -borderwidth 5 -relief sunken
        grid $screenFrame -column $gridCol -row $gridRow

        set screenInitialize "_initialize"
        set screenInitialize $aScreen$screenInitialize
        
        $screenInitialize
        
        screenM_rowCol $aScreen true
 

}

proc screenM_release { aScreen } {
        global openScreens
        set index [ lsearch $openScreens $aScreen ]
        if { $index != -1 } {
                set openScreens [lreplace $openScreens $index $index]
                set screenFrame ".f."
                set screenFrame $screenFrame$aScreen
                destroy $screenFrame
                screenM_rowCol $aScreen false
                writePrefFile
                set i 2
                foreach pScreen $openScreens {
                    set screenFrame ".f."
                    set screenFrame $screenFrame$pScreen
                    
                    
                    set gridCol [expr ($i % 2)]
                    set gridRow [expr ($i / 2)]
                    grid $screenFrame -column $gridCol -row $gridRow
                    incr i 1
                }
        }
}

proc screenM_rowCol { aScreen add } {
        global col row         
        if $add {
            incr row 1
        } else {
            incr row -1
        }        
}
