#tintTwo.gui.tcl
#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

package require Tk
#package require tooltip

################################################################
global deviceCount
global rcInt
if [info exists deviceCount] {
    puts "am solo"
    source lib/guiCMD.menu.tcl
    source lib/guiCMD.prefs.tcl
    source lib/guiCMD.screenM.tcl
    
   # source screens/wmctrl/wmctrl.gui.tcl
   # source screens/newFunction/newFunction.gui.tcl
 
    screenM_initialize
 
    guiCMD_prefs_initialize
} else {
    set deviceCount 1 
    cd screens/tintTwo
    #source xinput.tcl
}
source tintTwo.parse.tcl
source tintTwo.rcCreateUI.tcl
source tintTwo.file.tcl
source ../lib/preferenceHandler.tcl

##################################################################



proc tintTwo_initialize { } {
		#global .f.tintTwo
        global buttonKeys
	    global buttonKeys2
	    set buttonKeys [list]
	    set buttonKeys2 [list]	
       	global tintDir
		set tintDir "~/.config/tint2/"
		global rcInt
		set rcInt 0
		rcCreateUIinitialize
        set t2controlWindow ".f.tintTwo.control"
		#lappend buttonKeys2 $t2controlWindow
		labelframe $t2controlWindow -text "controls"	
		grid $t2controlWindow -column 0 -row 0 -columnspan 3
 
        button $t2controlWindow.h1 -text "tintOn" -command "tint2run"
        button $t2controlWindow.h2 -text "tintOff" -command "tint2stop"
        button $t2controlWindow.h3 -text "reConfig" -command "reConfig"
        button $t2controlWindow.h4 -text "restartTint" -command "tint2restart"
        grid $t2controlWindow.h1 -column 0 -row 0 
        grid $t2controlWindow.h2 -column 1 -row 0
        grid $t2controlWindow.h3 -column 2 -row 0
        grid $t2controlWindow.h4 -column 3 -row 0
        
        set t2controlConfigFiles ".f.tintTwo.configs"
		#lappend buttonKeys2 $t2controlConfigFiles
		labelframe $t2controlConfigFiles -text "config Files"	
		grid $t2controlConfigFiles -column 0 -row 1 -columnspan 3
        #grid .f.tintTwo.t1 -column 0 -row 1 -columnspan 
	global configFile
	readTintTwoPref
	parseConfig
}

proc reConfig {} {
	global configFile
	readTintTwoPref
	parseConfig
	
}

proc readConfigFile { index } {
	global configFile
	parseConfig2 $index	
	rcCreateUI
}


proc send_cmd { theCommand } {
    set outputList [list]
  set f [ open "| $theCommand" r]
  while {[gets $f output] >= 0} {
      puts $output
      lappend outputList $output
  }
  catch {close $f}
  return $outputList
}


proc send_cmd2 { theCommand } {
  global f
  set f [ open "| $theCommand" w]
  catch {close $f}
}

proc tint2run { } {
	set cmd "~/.config/tint2/tintTwo.config"
	send_cmd2 $cmd
}

proc tint2stop { } {
	set cmd "pkill tint2"
	send_cmd $cmd
}

proc tint2restart { } {
	set cmd "killall -SIGUSR1 tint2"
	send_cmd $cmd
}

