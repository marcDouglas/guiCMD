
proc readFileFromFolder { varName preferenceFolder } {

        file mkdir $preferenceFolder
        cd $preferenceFolder
        
        set filename $varName.txt
    
         
        if { [ file exists $filename ] == 1 } { 
                set fp [open $filename r]
                set input [read $fp]
                close $fp
                return $input
        } else {
            puts "error:$preferenceFolder - $varName - no file found (empty list returned)"
            return [list]      
        }
}

proc writeObjectToFile { varName preferenceFolder theVariable } {
    file mkdir $preferenceFolder
    cd $preferenceFolder
    set filename $varName.txt
    set fp [open $filename w]
    puts $fp $theVariable
    close $fp   
}
