proc ifSolo {} {
    if { [ file exists syncDrives.gui.tcl ] != 1 } {
      #  source syncDrives.gui.tcl
      cd
      cd screens/syncDrives
    }
}




proc syncDrives_initialize { } {
        ifSolo
        #frame .syncDrivessyncDrives
        #grid .syncDrives -column 0 -row 22     
        labelframe .f.syncDrives.localhost -text "localhost" -width 600 -height 100
        
        button .f.syncDrives.localhost.h1 -text "syncDrive" -command "syncDrive vader"
        button .f.syncDrives.localhost.h2 -text "umount" -command "umount vader"
        text .f.syncDrives.localhost.t0 -width 80 -height 34
        button .f.syncDrives.localhost.h3 -text "update status" -command "mountStatus vader2"
        .f.syncDrives.localhost.t0 insert end "Status Unknown"
        
        grid .f.syncDrives.localhost -column 0 -row 0
        grid .f.syncDrives.localhost.h1 -column 0 -row 0
        grid .f.syncDrives.localhost.h2 -column 1 -row 0
        grid .f.syncDrives.localhost.h3 -column 2 -row 0
        grid .f.syncDrives.localhost.t0 -column 0 -row 1 -columnspan 3
        proc outputParservader {cmdOutput host} {
            #.f.syncDrives.localhost.t0 delete 1.0 end
			.f.syncDrives.localhost.t0 insert end "$cmdOutput\n"
                update idletask

		}
        proc outputParservader2 {cmdOutput host} {
			#.f.syncDrives.localhost.t0 delete 1.0 end
			.f.syncDrives.localhost.t0 insert end "$cmdOutput\n"
		}        
 

}


proc send_cmd { theCommand theOutputHandler host } {
  global f
  set f [ open "| $theCommand |& cat" "r+"]
  fileevent $f readable "doThis $theOutputHandler $host"
}





proc syncDrive { host } {
    .f.syncDrives.localhost.t0 delete 1.0 end
	#set theCmd "lxterminal --command \"bin/syncDrive.sh\""
    set theCmd "bin/syncDrive.sh"
    ifSolo
    send_cmd $theCmd outputParser$host $host
    #mountStatus vader2
}

proc umount { host } {
    .f.syncDrives.localhost.t0 delete 1.0 end
	set theCmd "bin/umount.sh"
    send_cmd $theCmd outputParser$host $host	
    #mountStatus vader2
}

proc mountStatus { host } {
    .f.syncDrives.localhost.t0 delete 1.0 end
	set theCmd "df -h"
    send_cmd $theCmd outputParser$host $host	
	
}

proc parseCmdOut {cmdOutput} {
	.log insert end "$cmdOutput"
}

proc doThis { theOutputHandler host } {
  global f

  if { [eof $f] } {
	if {[catch {close $f}]} {
		$theOutputHandler "nil" $host
		return
	}	  

  } else {
		set isOutput 0
        while {[gets $f rawOutput] >= 0} {
            $theOutputHandler $rawOutput $host
            incr isOutput
        }        
        if { $isOutput == 0 } {
			$theOutputHandler "no output" $host
		}
  }
    #puts "finished doThis"
}
