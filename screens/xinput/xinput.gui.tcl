#xinput.gui
package require Tk
#package require tooltip

################################################################
global deviceCount
    
#if [info exists deviceCount] {
#    puts "am solo"
#} else {
    set deviceCount 1 
    cd screens/xinput
    source xinput.tcl
#}
source xinput.parse.tcl
source xinput.file.tcl
source ../lib/preferenceHandler.tcl

##################################################################

#global tpcolumn tprow

proc xinput_initialize { } {
    global masterCount masterList slaveList
    set masterCount -1
    set masterList [list]
    set slaveList [list]

    set aFrame ".f.xinput"
    
    frame .f.xinput.toolbar
    
    
    button .f.xinput.toolbar.refresh -text "refresh" -command "xinput_refreshList"
    entry .f.xinput.toolbar.entry -width 25
    button .f.xinput.toolbar.filter -text "filter" -command "xinput_filterList"
    
    grid .f.xinput.toolbar -column 0 -row 0 -columnspan 5
    grid .f.xinput.toolbar.refresh -column 0 -row 0
    grid .f.xinput.toolbar.entry -column 1 -row 0
    grid .f.xinput.toolbar.filter -column 2 -row 0    

 
    .f.xinput.toolbar.entry insert end [xinputFilter_value]
    xinput_start


}

proc addDeviceButtons { name title command {optionalCmds "" }} {
    global deviceCount masterCount masterList slaveList

    if { [string equal $optionalCmds "master"] } {
        incr masterCount 1   
        set aFrame ".f.xinput.mf"
        set aFrame $aFrame$name
       # puts "MASTER_FOUND:$aFrame"        
       labelframe $aFrame -border 5 -relief sunken -text "$title"
       #set plusOneMasterCount $masterCount
      # incr plusOneMasterCount 1
       grid $aFrame -column $masterCount -row 1
       lappend masterList $aFrame
       set deviceCount 0
       return
    }
    puts "masterCount:$masterCount"
    set aFrame [lindex $masterList $masterCount]
    set prefix .device
    set aFrame $aFrame$prefix$name
    
    set onButton ".onButton"
    set onButton $aFrame$onButton
    set offButton ".offButton"
    set offButton $aFrame$offButton


    set tprow [expr ($deviceCount % 5)]
    set tpcolumn [expr ($deviceCount / 5)]
    incr deviceCount 1                  
                
    labelframe $aFrame -text $title
    button $onButton -text "on" -command "xinput_enable_disable $name 1"
    button $offButton -text "off" -command "xinput_enable_disable $name 0"
    grid $aFrame -column $tpcolumn -row $tprow
    grid $onButton -column 0 -row 0
    grid $offButton -column 1 -row 0
    
    lappend slaveList $aFrame
    lappend slaveList $onButton
    lappend slaveList $offButton
}

proc tp_refreshWindows {} {
    tp_clearWindows
    xinput_start
    #send_cmd "/usr/bin/wmctrl -lp" wmctrl_parseInput
}

proc tp_clearWindows { } {
    global masterList slaveList masterCount
    puts "slaveList: $slaveList---\nmasterList:$masterList---"
    foreach slave $slaveList {
        destroy $slave
    }
    foreach masterFrame $masterList {
      destroy $masterFrame
    }
    set masterCount -1
    set masterList [list]
    set slaveList [list]

    #destroy .f.xinput

}
