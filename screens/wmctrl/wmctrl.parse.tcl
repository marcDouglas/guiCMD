proc wmctrl_parseInput {inputX} {
      global buttonKeys filterList13 numButCol

      if {[regexp -nocase {0x[a-f0-9]{8}} $inputX matched]} {
              set wordList [regexp -inline -all -- {\S+} $inputX]
              set i 0
              set tempTitle "" 
              foreach rec $wordList {
                switch $i {
                            "0" {  set tempHex $rec
                            #puts "hex: $tempHex"
                                        }
                            "1" {  set tempDesktop $rec
                            #puts "desktop: $tempDesktop"
                                        }
                            "2" {  set tempPid $rec
                            #puts "pid: $tempPid"
                                        }
                            "3" {  set tempMachine $rec
                            #puts "machine: $tempMachine"
                                        }
                            "4" { set tempTitle $rec 
                                        #puts "title: $tempTitle" 
                                        }
                            default {
                                        set tempTitle "$tempTitle $rec"
                                      }
                  }
                incr i 1
              }
              #end foreach 
            

            foreach filterItem $filterList13 {
                set filterItem ".*$filterItem.*"
                if { [regexp -nocase $filterItem $tempTitle matched] } {
                    set tempDesktop -1
                    continue
                }
            }
                
             if { $tempDesktop == -1  } {
                set tempTitle ""
            } else {
                wValues -add \
                    -setHex $tempHex \
                    -setDesktop $tempDesktop \
                    -setTitle $tempTitle\
                    -setPid $tempPid
                set tempIndex [wValues -returnLastIndex]
            }
                
              if {$tempTitle != ""} {      
                  set tempTitleShort [string range $tempTitle 0 20]            
                  set buttonKey ".f.wmctrl.$tempIndex"
                  set buttonTitle "$tempIndex $tempTitleShort"
                  set buttonHexKey "cButton $tempIndex"
                  
                  button $buttonKey -text $buttonTitle -command $buttonHexKey
                  


#taken out to fix tooltip error
                #tooltip::tooltip $buttonKey $tempTitle

                  set gridRow $tempIndex
                  set gridcol [expr ($gridRow % $numButCol)]
                  set gridRow [expr ($gridRow / $numButCol)]
                  incr gridRow 1
                  
                  grid $buttonKey -column $gridcol -row $gridRow -sticky w
                  lappend buttonKeys $buttonKey
                  #puts "button created!\n"
                  set tempTitle ""
              }
              return 1
            } else {
              puts "no window found"
              return 0
      }
}
