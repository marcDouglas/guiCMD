if { [ file exists syncDrives.gui.tcl ] != 1 } {
  #  source syncDrives.gui.tcl
  cd screens/syncDrives
}

#source syncDrives.dataObject.tcl
source ../lib/sudo.tcl
source syncDrives.file.tcl
#source syncDrives.parse.tcl
source ../lib/preferenceHandler.tcl


proc statusTextReplace {statusText} {
    .f.syncDrives.localhost.statusText delete 1.0 end
    .f.syncDrives.localhost.statusText insert end "$statusText\n"
}

proc chooseWhichBack {} {
    global scriptLocation
    global umountScriptLocation
    set host [info hostname] 

    switch $host {
        vishnu {
            set scriptLocation "bin/syncDrive.vishnu.sh"
            set umountScriptLocation "bin/umount.vishnu.sh"
            if { [ file isdirectory "/mnt/wishnu/backups/vishnu_7.7.17" ] == 1 } {
                .f.syncDrives.localhost.circle itemconfig t2 -extent 0
                statusTextReplace "Vishnu is ready to backup to Wishnu."
            } else {
                .f.syncDrives.localhost.circle itemconfig t2 -extent 359
                statusTextReplace "Wishnu is not mounted. Update Status"
            }
        }
        flower {
            set scriptLocation "bin/syncDrive.flower.sh"
            set umountScriptLocation "bin/umount.flower.sh"
            if { [ file isdirectory "/run/media/shawna/BumbleBee/backups/flower.11.2.17" ] == 1 } {
                .f.syncDrives.localhost.circle itemconfig t2 -extent 0
                statusTextReplace "Flower is ready to backup to BumbleBee."
            } else {
                .f.syncDrives.localhost.circle itemconfig t2 -extent 359
                statusTextReplace "BumbleBee is not mounted. Update Status"
            }               
        } 
        vader {
           set scriptLocation "bin/syncDrive.vader.sh"
           set umountScriptLocation "bin/umount.vader.sh"
           if { [ file isdirectory "/run/media/marc/wishnu/backups/vader.ssh.bkup" ] == 1 } {
                .f.syncDrives.localhost.circle itemconfig t2 -extent 0
                statusTextReplace "Vader is ready to backup to Wishnu."
            } else {
                .f.syncDrives.localhost.circle itemconfig t2 -extent 359
                statusTextReplace "Wishnu is not mounted. Update Status"
            }
        }
        default {
            set scriptLocation "bin/syncDrive.sh"
            set umountScriptLocation "bin/umount.sh"
            guiTextInsert $scriptLocation
        }
    }
  
}

proc syncDrives_initialize { } {
        global scriptLocation
        global syncCommand
        
        #frame .syncDrivessyncDrives
        #grid .syncDrives -column 0 -row 22     
        labelframe .f.syncDrives.localhost -text "localhost" -width 600 -height 100
        
        button .f.syncDrives.localhost.h1 -text "syncDrive" -command "syncDrive"
        button .f.syncDrives.localhost.h2 -text "umount" -command "umount"
        text .f.syncDrives.localhost.t0 -width 80 -height 24
        button .f.syncDrives.localhost.h3 -text "update status" -command "mountStatus"
        .f.syncDrives.localhost.t0 insert end ""
        
        #set tagCircle "statusCircle"
        canvas .f.syncDrives.localhost.circle -width 25 -height 25 -highlightt 0
        .f.syncDrives.localhost.circle create oval 2 2 24 24 -tags t1 -fill green -outline ""
		.f.syncDrives.localhost.circle create arc 2 2 24 24 -tags t2 -fill red -extent 359 -outline ""
		#.f.piControl.localhost.circle itemconfig t2 -extent 180
        text .f.syncDrives.localhost.statusText -width 40 -height 1
        
        
       # menu .f.syncDrives.localhost.m0 -textvariable "backupLocal" -indicatoron 1 \
            -relief raised -highlightthickness 1 -anchor c \
            -direction flush
      #  menu .f.syncDrives.localhost.m0 -tearoff 0
      #  .f.syncDrives.localhost.m0.f.syncDrives.localhost.m0 add command -label "one"
      #  .f.syncDrives.localhost.m0.f.syncDrives.localhost.m0 add command -label "number2"

        
        grid .f.syncDrives.localhost -column 0 -row 0
        grid .f.syncDrives.localhost.h1 -column 0 -row 1
        grid .f.syncDrives.localhost.h2 -column 1 -row 1
        grid .f.syncDrives.localhost.h3 -column 2 -row 1
        grid .f.syncDrives.localhost.circle -column 0 -row 0
        grid .f.syncDrives.localhost.statusText -column 1 -row 0
       # grid .f.syncDrives.localhost.m0 -column 3 -row 0
        grid .f.syncDrives.localhost.t0 -column 0 -row 2 -columnspan 3
        
        

        

        chooseWhichBack
}

proc guiTextInsert {cmdOutput} {
    #.f.syncDrives.localhost.t0 delete 1.0 end
    .f.syncDrives.localhost.t0 insert end "$cmdOutput\n"
        update idletask
}

proc guiTextReplace {cmdOutput} {
    .f.syncDrives.localhost.t0 delete 1.0 end
    .f.syncDrives.localhost.t0 insert end "$cmdOutput\n"
}


        
proc send_cmd { theCommand theOutputHandler  } {
  global f
  set f [ open "| $theCommand |& cat" "r+"]
  fileevent $f readable "doThis $theOutputHandler"
}

proc syncDrive { } {
    global scriptLocation
 #   guiTextInsert $scriptLocation
   # .f.syncDrives.localhost.t0 delete 1.0 end
	set theCmd "lxterminal --command $scriptLocation"
	#set theCmd "lxterminal --command \"bin/syncDrive.sh\""
    #set theCmd "bin/syncDrive.sh"
    #ifSolo
    send_cmd $theCmd guiTextInsert
    guiTextInsert "$scriptLocation is executing in outside window."
}

proc umount {  } {
    global umountScriptLocation
    .f.syncDrives.localhost.t0 delete 1.0 end
	#set theCmd "bin/umount.sh"
    set theCmd "lxterminal --command $umountScriptLocation"

    send_cmd $theCmd guiTextInsert	

}

proc mountStatus {  } {
    .f.syncDrives.localhost.t0 delete 1.0 end
	set theCmd "df -h"
    send_cmd $theCmd guiTextInsert	
    chooseWhichBack
	
}

proc parseCmdOut {cmdOutput} {
	.log insert end "$cmdOutput"
}

proc doThis { theOutputHandler  } {
  global f

  if { [eof $f] } {
	if {[catch {close $f}]} {
		$theOutputHandler "nil" 
        
		return
	}	  

  } else {
		set isOutput 0
        while {[gets $f rawOutput] >= 0} {
            $theOutputHandler $rawOutput
            incr isOutput
        }        
        if { $isOutput == 0 } {
			$theOutputHandler "no output"
		}
  }
    #puts "finished doThis"
}
