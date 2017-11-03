

proc xinput_parser2 { aLine filterItem } {
    set devName [list]
    set id -1
    set masterDev -1
    set type notSetYet
    
    foreach lineSegment $aLine {

        
        if { $id < 0 }  {
            if [string equal -length 3 $lineSegment "id="] {
                    set idSplit [split $lineSegment "="]
                    set id [lindex $idSplit 1]
            }
            lappend devName $lineSegment
        } else {
            if { $masterDev < 0 } {
                if [string equal -length 3 $lineSegment "\[master"] {
                        set masterDev 1
                        #addDeviceButtons $id $devName "devDisable $id" master
                }
                if [string equal -length 3 $lineSegment "\[slave"] {
                        set masterDev 0
                       if { [regexp -nocase $filterItem $devName matched] } {
                            puts "MATCH: $id $devName"
                            return $id
                       }
                }           
                
            } else {
                if { $type == "notSetYet" } {
                    set type $lineSegment
                } else {
                    set okNum [string range $lineSegment 1 1]
                    #puts "type:$type uk:$okNum"
                }
                    
                
            }
            

        }
    }
    #puts "id:$id-$masterDev devName:$devName  type:$type uk:$okNum"
    return -1
    
}


