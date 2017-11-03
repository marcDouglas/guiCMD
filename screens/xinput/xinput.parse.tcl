
proc xinput_xinput_parser { rawOutput } {
    set devName [list]
    set id -1
    set masterDev -1
    set type notSetYet
    
    foreach line $rawOutput {

        
        if { $id < 0 }  {
            if [string equal -length 3 $line "id="] {
                    set idSplit [split $line "="]
                    set id [lindex $idSplit 1]
            }
            lappend devName $line
        } else {
            if { $masterDev < 0 } {
                if [string equal -length 3 $line "\[master"] {
                        set masterDev 1
                        addDeviceButtons $id $devName "devDisable $id" master
                }
                if [string equal -length 3 $line "\[slave"] {
                        set masterDev 0
                       if { [regexp -nocase [xinputFilter_value] $devName matched]  || [xinputFilter_length] == 0 } {
                            addDeviceButtons $id $devName "devDisable $id"
                       }
                }           
                
            } else {
                if { $type == "notSetYet" } {
                    set type $line
                } else {
                    set okNum [string range $line 1 1]
                    #puts "type:$type uk:$okNum"
                }
                    
                
            }
            

        }
    }
}
