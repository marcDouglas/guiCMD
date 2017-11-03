#!/usr/bin/tclsh

# wHex is used as the master list for wCount. 




proc wValues {args} {
    global wValues wTitle wHex wDesktop wWorkingIndex wPIDs
    if [info exists wValues] {
        #puts "\nwValues Exists."
    } else {
        set wValues Exists
        set wCount 99
        set wHex [list]

        #puts "\nwValues created."
    }
    
        set wIndex empty
        set wCommand empty
        set arg1 empty
        set arg2 empty

    
    foreach {wArgs} $args {
            if { $wArgs ==  "-reset" } {
                set wHex [list]
                set wTitle [list]
                set wPIDs [list]
            } elseif { [string is integer $wArgs] && $wIndex == "empty"} {
                if { $wArgs >= 0} {
                    #puts "wIndex: $wArgs"
                    set wIndex $wArgs
                    set wWorkingIndex $wArgs
                } else {
                    puts "wIndex is $wArgs --?? "
                }
            } else {
                if {$wCommand == "empty"}  {
                    set wCommand $wArgs
                    switch $wCommand {
                            "-add" {
                                set wIndex  [ llength $wHex]
                                set wWorkingIndex $wIndex
                                lappend wHex empty
                                lappend wTitle empty
                                lappend wDesktop empty
                                lappend wPIDs empty
                                set wCommand empty
                             } "-removeLast" {
                                set wIndex  [ llength $wHex]
                                incr wIndex -1
                                set wWorkingIndex $wIndex
                                set wHex [lreplace $wHex $wIndex $wIndex]
                                set wTitle [lreplace $wTitle $wIndex $wIndex]
                                set wDesktop [lreplace $wDesktop $wIndex $wIndex]                                
                                set wPIDs [lreplace $wPIDs $wIndex $wIndex]
                             } "-hex" {
                                if  { $wIndex == "empty" } { 
                                    puts "-hex requires index as first argument"
                                } else {
                                    set tempHex [lindex $wHex $wIndex]
                                    return [lindex $wHex $wIndex]
                                }
                            } "-title" {
                                if  { $wIndex == "empty" } { 
                                    puts "-title requires index as first argument"
                                } else {
                                    return [lindex $wTitle $wIndex]
                                }
                            } "-desktop" {
                                if  { $wIndex == "empty" } { 
                                    puts "-desktop requires index as first argument"
                                } else {
                                    return [lindex $wDesktop $wIndex]
                                }
                            } "-pid" {
                                if  { $wIndex == "empty" } { 
                                    puts "-desktop requires index as first argument"
                                } else {
                                    return [lindex $wPIDs $wIndex]
                                }
                            } "-returnLastIndex" {
                                #puts "RETURN currentIndex"
                                return $wWorkingIndex
                            } "-total" {
                                #set wIndex $wWorkingIndex
                                puts "-total - not Implemented"
                                set wCommand empty
                            } "-removeItem" {
                                if  { $wIndex == "empty" } { 
                                    puts "-removeItem requires index as first argument"
                                } else {
                                    set wHex [lreplace $wHex $wIndex $wIndex]
                                    set wTitle [lreplace $wTitle $wIndex $wIndex]
                                    set wDesktop [lreplace $wDesktop $wIndex $wIndex]
                                    set wPIDs [lreplace $wPIDs $wIndex $wIndex]
                                    return
                                }
                            } "-useLastIndex" {
                                set wIndex $wWorkingIndex
                                set wCommand empty
                            } default {
                                #puts "1st level command not found"
                            }
                    }
                } elseif {$arg1 == "empty"} {
                        set arg1 $wArgs
                        switch $wCommand {
                            "-setHex" {
                                if  { $wIndex != "empty"} {
                                    #puts "setHex($wIndex)= $arg1"
                                    
                                    set wHex [lreplace $wHex $wIndex $wIndex $arg1]
                                    #puts $wHex
                                    set arg1 empty
                                    set wCommand empty
                                } else {
                                    if  { $wIndex == "empty" } {
                                        puts "-hex requires index as first argument"
                                    } else {
                                        puts "ERROR: wIndex:$wIndex > wCount:$wCount"
                                    }
                                }
                            } "-setTitle" {
                                if  { $wIndex != "empty" } { 
                                    #puts "setTitle($wIndex)= $arg1"
                                     set wTitle [lreplace $wTitle $wIndex $wIndex $arg1]
                                     #puts $wTitle
                                     set arg1 empty
                                     set wCommand empty
                                } else {
                                    puts "-setTitle requires index set first. \nex. wValues 4 -setTitle $arg1"
                                }
                                set wCommand empty
                                set arg1 empty
                            } "-setDesktop" {
                                    if  { $wIndex != "empty" } { 
                                     set wDesktop [lreplace $wDesktop $wIndex $wIndex $arg1]
                                     set arg1 empty
                                     set wCommand empty
                                } else {
                                    puts "-setTitle requires index set first. \nex. wValues 4 -setDesktop $arg1"
                                }
                                set wCommand empty
                                set arg1 empty
                            } "-setPid" {
                                    if  { $wIndex != "empty" } { 
                                     set wPIDs [lreplace $wPIDs $wIndex $wIndex $arg1]
                                     set arg1 empty
                                     set wCommand empty
                                } else {
                                    puts "-setPid requires index set first. \nex. wValues 4 -setPid $arg1"
                                }
                                set wCommand empty
                                set arg1 empty
                            } "-titlesMatching" {
                                return [lsearch $wTitle $arg1]
                            } "-setCurrentIndex" {
                                puts "-setCurrentIndex Not implemented"
                            } default {
                                #puts "2nd level command not found"
                            }
                    }
                } elseif {$arg2 == "empty"} {
                    #we are done here
                    
                } else {
                    puts "butterflies"
                }
            }
            
        }
    set wWorkingIndex $wIndex

}

#wValues -2
#wValues 0

#wValues -hex
#wValues -currentIndex
#wValues -currentCount

#wValues 101 -setHex 5
#wValues 22 -hex
#wValues 33 -setHex 5 -setHex 11
#wValues 44 -setTitle "awesome Window Titles are Here"
#wValues -add -setHex 666 -setTitle "six six six "
#wValues -add -setHex 777 -setTitle "sev sev sev "
#wValues 1 -setHex 888 -setTitle "eight eight eight "
#wValues -add -setHex 999 -setTitle "nine nine nine "
#wValues 2 -setHex 111 -setTitle "one one one"
#wValues -removeLast
#wValues -removeLast
#wValues -reset
#wValues -add -setHex 222 -setTitle "two two two"





#proc butterflies {  head body wi ngs  } {
proc εiiз { ii  vv } {
    # ✿  ❀  ❁  ✾ vv √  ๏ 
        # ❁  0  lotus - infinite - perfection
        # ❀  1  at One - near perfect
        # ✿  2  dual nature - mostly works, but handles errors badly
        # ✾  3   50/50 or worse, error handle may be non-existant
        # √   4   checking this . in progress . volitale
        # ๏  5  target item - under revision now
    #body - message
    #wings - escape sequence
     
    global bb
    if { ! [info exists bb] } {
        set bb "[clock format [clock seconds] -format {%b. %d, %Y %I:%M:%S %p}]"
        puts "created εiiз $bb"
    }
    puts -nonewline "εiiз "
  
    switch $ii { 
                "0" { puts "❁ 0: $vv" }
                "1" { puts "❀ 1:$vv" }
                "2" { puts "✿ 2:$vv"}
                "3" { puts "✾ 3: $vv" }
                "4" { puts "√ 4:$vv" }
                "5" { puts "๏ 5:$vv"}                
                "❁" { puts "❁ 0:$vv" }
                "❀" { puts "❀ 1:$vv" }
                "✿" { puts "✿ 2:$vv"}
                "✾" { puts "✾ 3:$vv" }
                "๏" { puts "√ 4:$vv" }
                "√" { puts "๏ 5:$vv"}                
                default { puts "•*´¨`*•.¸¸.•*´¨`*•.¸¸.•*´¨`*•.¸¸.•*´¨`*•.¸¸.•\
                                            \n        Let the answer flow to you...
                                            \n                  $vv\n\
                                            •*´¨`*•.¸¸.•*´¨`*•.¸¸.•*´¨`*•.¸¸.•*´¨`*•.¸¸.•" }
    } 
}
   # ✿  ❀  ❁  ✾ vv √  ๏ 
        # ❁  0  lotus - infinite - perfection
        # ❀  1  at One - near perfect
        # ✿  2  dual nature - mostly works, but handles errors badly
        # ✾  3   50/50 or worse, error handle may be non-existant
        # √   4   checking this . in progress . volitale
        # ๏  5  target item - under revision now
    #body - message
    #wings - escape sequence

εiiз ❁ "0  lotus - infinite - perfection"
εiiз ❀ "1  at One - near perfect"
εiiз ✿ "2  dual nature - mostly works, but handles errors badly"
εiiз ✾ "3  50/50 or worse, error handle may be non-existant"
εiiз ๏ "4  checking this . in progress . volitale"
εiiз √ "5  target item - under revision now"
εiiз √√ "the answer is before you"
