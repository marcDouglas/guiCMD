#added for remote Launch++++++++++++++++
package require Tk
#package require tooltip

global wmctrl
    
if [info exists wmctrl] {
    puts "am solo"
   # source wmctrl.gui.tcl
} else {

    set wmctrl "/usr/bin/wmctrl"
    cd screens/wmctrl
    source wmctrl.tcl
}

source wmctrl.dataObject.tcl
source sudo.tcl
source wmctrl.file.tcl
source wmctrl.parse.tcl
source ../lib/preferenceHandler.tcl



proc wmctrl_requested {} {
     global openScreens
     if { [ lsearch $openScreens "wmctrl" ] == -1 } {
            wmctrl_create
            lappend openScreens "wmctrl"
            guiCMD_prefs_write
     } else {
            wmctrl_release
     }
}


proc wmctrl_initialize {  } {

        global popupMenu
        #frame .wmctrl
        frame .f.wmctrl.top -borderwidth 5 -width 800 -height 400
        frame .f.wmctrl.top.leftw -width 300 -height 100
        frame .f.wmctrl.top.rightw -width 300 -height 100
        
        labelframe .f.wmctrl.top.leftw.basic -text "basic"      
        button .f.wmctrl.top.leftw.basic.refresh -text "Refresh" -command wmctrl_refreshWindows        
        button .f.wmctrl.top.leftw.basic.guiCMD -text "guiCMD" -command guiCMDstart        
        label .f.wmctrl.top.leftw.basic.numColumns -text "# of columns"
        
        
        labelframe .f.wmctrl.top.rightw.filterFrame -text "filter windows by name"
        button .f.wmctrl.top.rightw.filterFrame.addFilter -text "addFilter" -command wmctrl_filterList_add        
        button .f.wmctrl.top.rightw.filterFrame.removeFilter -text "removeFilter" -command wmctrl_filterList_remove
        listbox .f.wmctrl.top.rightw.filterFrame.filterListbox -selectmode single
        entry .f.wmctrl.top.rightw.filterFrame.filter
        
        labelframe .f.wmctrl.top.rightw.options -text "options"
        checkbutton .f.wmctrl.top.rightw.options.fullscreen -text "fullscreen" -variable c1
        checkbutton .f.wmctrl.top.rightw.options.killwindow -text "kill window" -variable c2
        checkbutton .f.wmctrl.top.rightw.options.killAllWindow -text "kill Similiar" -variable c3   
        
        labelframe .f.wmctrl.top.leftw.nice -text renice     
        checkbutton .f.wmctrl.top.leftw.nice.superNice -text "super nice" -variable c4
        checkbutton .f.wmctrl.top.leftw.nice.normalNice -text "normal nice" -variable c5        
        checkbutton .f.wmctrl.top.leftw.nice.barelyNice -text "barely nice" -variable c6
          
        #grid .wmctrl -column 0 -row 0
        grid .f.wmctrl.top -column 0 -row 0 -columnspan 8 -sticky w
        
        grid .f.wmctrl.top.leftw -column 0 -row 0 -columnspan 2 -sticky w
        grid .f.wmctrl.top.rightw -column 3 -row 0 -columnspan 6 -sticky w
        
        grid .f.wmctrl.top.leftw.basic -column 0 -row 0
        grid .f.wmctrl.top.leftw.basic.refresh -column 0 -row 0  -sticky w
        grid .f.wmctrl.top.leftw.basic.guiCMD -column 0 -row 1 -sticky w
        ###################################################
        grid .f.wmctrl.top.leftw.basic.numColumns -column 0 -row 2 -sticky w
        ###################################################
        
        
        grid .f.wmctrl.top.rightw.filterFrame -column 0 -row 0 -columnspan 2 -rowspan 4
        grid .f.wmctrl.top.rightw.filterFrame.filter -column 0 -row 6 -sticky w
        grid .f.wmctrl.top.rightw.filterFrame.addFilter -column 3 -row 1 -sticky w
        grid .f.wmctrl.top.rightw.filterFrame.removeFilter -column 3 -row 2 -sticky w
        grid .f.wmctrl.top.rightw.filterFrame.filterListbox -column 0  -row 0 -rowspan 6 -sticky w
                       
        grid .f.wmctrl.top.rightw.options -column 2 -row 3 
        grid .f.wmctrl.top.rightw.options.fullscreen -column 0 -row 0 -sticky w
        grid .f.wmctrl.top.rightw.options.killwindow -column 0 -row 1 -sticky w
        grid .f.wmctrl.top.rightw.options.killAllWindow -column 0 -row 2 -sticky w
        
        grid .f.wmctrl.top.leftw.nice -column 0 -row 2 
        grid .f.wmctrl.top.leftw.nice.superNice -column 0 -row 0 -sticky w
        grid .f.wmctrl.top.leftw.nice.normalNice -column 0 -row 1 -sticky w
        grid .f.wmctrl.top.leftw.nice.barelyNice -column 0 -row 2    -sticky w
#######################################################
        # Create a menu
        if   { [info exists popupMenu ] }   { 
            puts "menuExists! rebinding..." 
            bind .f.wmctrl.top.leftw.basic.numColumns <1> {tk_popup .popupMenu %X %Y}
        } else {
            set popupMenu [menu .popupMenu -tearoff 0] 
            #$m
            $popupMenu add command -label "set # columns 2" -command { bell 2 }        
            $popupMenu add command -label "set # columns 3" -command { bell 3 }
            $popupMenu add command -label "set # columns 4" -command { bell 4 }
            $popupMenu add command -label "set # columns 5" -command { bell 5 }
                    
            bind .f.wmctrl.top.leftw.basic.numColumns <1> {tk_popup .popupMenu %X %Y}
        }

#######################################################    
        global buttonKeys
        set buttonKeys [list]
        wmctrl_filterList_read
        wmctrl_filterList_refresh

        #send_command
        #send_cmd "/usr/bin/wmctrl -lp" wmctrl_parseInput
}

proc bell { numCol } { 

    global numButCol
    set numButCol $numCol
    wmctrl_refreshWindows
}
    
proc wmctrl_refreshWindows {} {
    clearButtons
    send_cmd "/usr/bin/wmctrl -lp" wmctrl_parseInput
}

proc clearButtons {} {
    global buttonKeys
    foreach buttonKey $buttonKeys {
      destroy $buttonKey
      #puts "bKey: $buttonKey"
    }
    wValues -reset
}

proc send_cmd { theCommand theOutputHandler} {
  set f [ open "| $theCommand" r]
  while {[gets $f rawOutput] >= 0} {
      $theOutputHandler $rawOutput
  }
  catch {close $f}
}

proc buttonFullscreen { buttonHex } {
    puts $buttonHex
    global wmctrl
    set action "-i -r $buttonHex -b toggle,fullscreen"   
    set f [ open "| $wmctrl $action" r]
    catch {close $f}
}

proc buttonKillOne { thePid } {
    puts "killOne"

    if { $thePid != "empty" } {
        set action "$thePid"   
        set f [ open "| kill $action" r]
        catch {close $f}
    } else {
        puts "no pid!"
    }
}

proc buttonKillAll { theTitle } {
    puts "killAll"
    global wValues
    set finished 0
    while { ! $finished } {
        set matchedIndex [wValues 0 -titlesMatching $theTitle]
        if { $matchedIndex != -1 } {
            puts "target:$theTitle found: =$matchedIndex="
            buttonKillOne [wValues $matchedIndex -pid]
            wValues $matchedIndex -removeItem
        } else {
            set finished 1
        }
    }

}

proc cButton { tempIndex } {
    global wValues
    variable c1
    variable c2
    variable c3
    variable c4
    variable c5
    variable c6
       
    puts "fullscreen:$c1 killw:$c2 killAll:$c3"

    if $c1 {
        set buttonHex [wValues $tempIndex -hex]
        buttonFullscreen $buttonHex
    }
    if $c3 {
        buttonKillAll [wValues $tempIndex -title]
        wmctrl_refreshWindows
    } elseif $c2 {
        buttonKillOne [wValues $tempIndex -pid]
        [wValues $tempIndex -removeItem]
        wmctrl_refreshWindows
    } elseif $c4 {
        set sudo [sudo:run [list renice -15 [wValues $tempIndex -pid]]]ls
        vwait ${sudo}(done)
    } elseif $c5 {
        set sudo [sudo:run [list renice -0 [wValues $tempIndex -pid]]]ls
        vwait ${sudo}(done)
    } elseif $c6 {
        set sudo [sudo:run [list renice 15 [wValues $tempIndex -pid]]]ls
        vwait ${sudo}(done)
    }
}
