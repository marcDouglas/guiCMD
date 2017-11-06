    proc rawConky_value {} {
            global rawConky
            if {$rawConky == 1} {
                puts "set RawConky"
                conky_read
            }
            return $rawConky
    }

    proc conky_read {} {
    
            global rawConky
            cd ~
            if { [ file exists .conkyrc ] == 1 } { 
                    puts READINGinORIGINAL
                    set fp [open .conkyrc r]
                    set rawConky [read $fp]
                    close $fp
                    #cd $homeDir
        
            } else {
               puts "error no .conkyrc found"
                #set inputFile [list]      
            }
            
            puts $rawConky

    }
    
    proc writeconky { newConky } {
        cd ~
        set fp [open .conkyrc w]
        foreach conkyLine $newConky {
            puts $fp $conkyLine
        }
        close $fp   
    }

   
proc conkyWriteChanges {} {
        global conkyArray matchList
        set rawConky [rawConky_value]
        set i 0
        set lineByline [split $rawConky "\n"]
        set newConky [list]
        foreach line $lineByline {
            set success no
            foreach matchItem $matchList {
                 if  { [ lsearch $line $matchItem ]  == 0 } {
                    lappend newConky "$matchItem $conkyArray($matchItem)"
                    set success yes
                 }
            }
            if { ! $success } {
                lappend newConky "$line"
            }
        }
        #set newConky [join $newConky " "]
        #puts $newConky
        writeconky $newConky
}
