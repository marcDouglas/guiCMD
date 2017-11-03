    
    proc screenM_find {} {
        cd screens
        set files [glob *]
        set directories [list]
        foreach fl $files {
            if { [file isdirectory $fl] } {
                #puts "$fl is a directory"
                lappend directories $fl
            }
        }
        #puts $directories
        
        set postFix ".gui.tcl"
        
        set checkedDir [list]
        
        foreach dir $directories {
            cd $dir
            set testFile $dir$postFix
            
            if { [file isfile $testFile] } {
                #puts "isAfile : $testFile - $dir"
                lappend checkedDir $dir
            }
            cd ..
        }
        
        #puts "checkedDirs: $checkedDir"
        
        cd ..
        return $checkedDir
}

 #set temptemp [screenM_find]
 #puts [screenM_find]

