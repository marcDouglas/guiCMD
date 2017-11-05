if { [ file exists syncDrives.gui.tcl ] != 1 } {
  #  source syncDrives.gui.tcl
  cd screens/syncDrives
}

#source syncDrives.dataObject.tcl
source ../lib/sudo.tcl
source syncDrives.file.tcl
#source syncDrives.parse.tcl
source ../lib/preferenceHandler.tcl






proc syncDrives_initialize { } {
        global scriptLocation
        global syncCommand
        
        #frame .syncDrivessyncDrives
        #grid .syncDrives -column 0 -row 22     
        labelframe .f.syncDrives.localhost -text "localhost" -width 600 -height 100
        
        button .f.syncDrives.localhost.h1 -text "syncDrive" -command "syncDrive"
        button .f.syncDrives.localhost.h2 -text "umount" -command "umount"
        text .f.syncDrives.localhost.t0 -width 80 -height 34
        button .f.syncDrives.localhost.h3 -text "update status" -command "mountStatus"
        .f.syncDrives.localhost.t0 insert end ""
        
       # menu .f.syncDrives.localhost.m0 -textvariable "backupLocal" -indicatoron 1 \
            -relief raised -highlightthickness 1 -anchor c \
            -direction flush
      #  menu .f.syncDrives.localhost.m0 -tearoff 0
      #  .f.syncDrives.localhost.m0.f.syncDrives.localhost.m0 add command -label "one"
      #  .f.syncDrives.localhost.m0.f.syncDrives.localhost.m0 add command -label "number2"

        
        grid .f.syncDrives.localhost -column 0 -row 0
        grid .f.syncDrives.localhost.h1 -column 0 -row 0
        grid .f.syncDrives.localhost.h2 -column 1 -row 0
        grid .f.syncDrives.localhost.h3 -column 2 -row 0
       # grid .f.syncDrives.localhost.m0 -column 3 -row 0
        grid .f.syncDrives.localhost.t0 -column 0 -row 1 -columnspan 3
        
        
        proc guiTextInsert {cmdOutput} {
            #.f.syncDrives.localhost.t0 delete 1.0 end
			.f.syncDrives.localhost.t0 insert end "$cmdOutput\n"
                update idletask
		}
        
        proc guiTextReplace {cmdOutput} {
			.f.syncDrives.localhost.t0 delete 1.0 end
			.f.syncDrives.localhost.t0 insert end "$cmdOutput\n"
		} 
               
 
        proc chooseWhichBack {} {
            global scriptLocation
            global umountScriptLocation
            set host [info hostname] 
            
            #if { [ file isdirectory "/mnt/wishnu/backups/vishnu_7.7.17" ] == 1 } {
                #outputParser [info hostname]
                #set scriptLocation "bin/syncDrive.vishnu.sh"
                #outputParser $scriptLocation
               ## set syncCommand "sudo rsync -aAXv --delete --exclude={\"/dev/*\",\"/proc/*\",\"/sys/*\",\"/tmp/*\",\"/run/*\",\"/mnt/*\",\"/media/*\",\"/lost+found\",\"/srv/*\",\"home/marc/build/*\",\"/var/cache/pacman/pkg\",\"/home/marc/.android/*\",\"/home/marc/.cache/*\",\"home/marc/.local/share/Steam/*\",\"home/marc/documents/marcDouglas.us/public_html/android-apps/*\",\"/home/marc/downloads/*\",\"/opt/android-ndk/*\",\"/opt/android-studio/*\",\"/home/marc/.kodi/userdata/*\"} / /mnt/wishnu/backups/vishnu_7.7.17/"
                ##outputParser $syncCommand
            #} elseif { [ file isdirectory "/run/media/shawna/BumbleBee/backups/flower.11.2.17" ] == 1 } {
                #set scriptLocation "/run/media/shawna/BumbleBee/backups/flower.11.2.17"
                #outputParser $scriptLocation      
            #}
            
            
            switch $host {
                vishnu {
                    set scriptLocation "bin/syncDrive.vishnu.sh"
                    set umountScriptLocation "bin/umount.vishnu.sh"
                   # guiTextInsert $scriptLocation
                }
                flower {
                    set scriptLocation "bin/syncDrive.flower.sh"
                    set umountScriptLocation "bin/umount.flower.sh"
                #    guiTextInsert $scriptLocation
                } 
                default {
                    set scriptLocation "bin/syncDrive.sh"
                    set umountScriptLocation "bin/umount.sh"
                    guiTextInsert $scriptLocation
                }
            }
            
            
            
            
            
        }

        chooseWhichBack
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


}

proc umount {  } {
    global umountScriptLocation
    .f.syncDrives.localhost.t0 delete 1.0 end
	#set theCmd "bin/umount.sh"
    send_cmd $umountScriptLocation guiTextInsert	

}

proc mountStatus {  } {
    .f.syncDrives.localhost.t0 delete 1.0 end
	set theCmd "df -h"
    send_cmd $theCmd guiTextInsert	
	
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
