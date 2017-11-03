#xinputConfig

proc devDisable { x } {
    
}

proc send_cmd { theCommand theOutputHandler} {
  set f [ open "| $theCommand" r]
  while {[gets $f rawOutput] >= 0} {
      $theOutputHandler $rawOutput
  }
  catch {close $f}
}

proc xinput_enable_disable { id onWitch } {

            set cmd "xinput set-prop $id \"Device Enabled\" $onWitch"
            send_cmd $cmd puts         
}

proc xinput_refreshList { } {
    tp_refreshWindows
}

proc xinput_filterList { } {
        xinputFilter_setValue [.f.xinput.toolbar.entry get]
        xinputFilter_write
        tp_refreshWindows
}

proc xinput_start {} {
    send_cmd xinput xinput_xinput_parser
    
}


#########################################################
proc xinput_self_initialize {} {
        frame .f
        grid .f -column 0 -row 0
      #  puts "self_initialize :wmctrl"

        frame .f.xinput -borderwidth 5 -relief sunken
        grid .f.xinput -column 0 -row 0

        xinput_initialize
        #startxinput
}

proc ifSolo {} {
    global deviceCount
    if [info exists deviceCount] {
        #startxinput
    } else {
        set deviceCount 0
        source xinput.gui.tcl
        xinput_self_initialize
    }
}

ifSolo
###########################################################
