proc piControl_initialize { } {
        #frame .piControl
        #grid .piControl -column 0 -row 22     
        labelframe .f.piControl.localhost -text "localhost" -width 600 -height 100
        
        button .f.piControl.localhost.h1 -text "mount" -command "mount vader"
        button .f.piControl.localhost.h2 -text "umount" -command "umount vader"
        text .f.piControl.localhost.t0 -width 80 -height 3
        button .f.piControl.localhost.h3 -text "update status" -command "mountStatus vader2"
        .f.piControl.localhost.t0 insert end "Status Unknown"
        
        grid .f.piControl.localhost -column 0 -row 0
        grid .f.piControl.localhost.h1 -column 0 -row 0
        grid .f.piControl.localhost.h2 -column 1 -row 0
        grid .f.piControl.localhost.h3 -column 2 -row 0
        grid .f.piControl.localhost.t0 -column 0 -row 1 -columnspan 3
        proc outputParservader {cmdOutput host} {
			.f.piControl.localhost.t0 insert end "$cmdOutput\n"
		}
        proc outputParservader2 {cmdOutput host} {
			.f.piControl.localhost.t0 delete 1.0 end
			.f.piControl.localhost.t0 insert end "$cmdOutput\n"
		}        
        set hosts { pi314 pi315 piMaster}
        set hostRow 1
        foreach { host } $hosts {
				labelframe .f.piControl.$host -text "$host" -width 600 -height 100
				
				canvas .f.piControl.$host.circle -width 50 -height 50 -highlightt 0
				.f.piControl.$host.circle create oval 2 2 48 48 -tags t1$host -fill green -outline ""
				.f.piControl.$host.circle create arc 2 2 48 48 -tags t2$host -fill red -extent 0 -outline ""
				.f.piControl.$host.circle itemconfig t2$host -extent 180							
		        button .f.piControl.$host.h1 -text "status" -command "updateStatus $host"
		        button .f.piControl.$host.h2 -text "ping" -command "ping $host"		        
		        button .f.piControl.$host.h3 -text "re-WIFI" -command "restartWifi $host"
		        button .f.piControl.$host.h4 -text "re-KODI" -command "restartKodi $host"
		        button .f.piControl.$host.h5 -text "restart" -command "restartSys $host"
		        button .f.piControl.$host.h6 -text "shutdown" -command "shutdownSys $host"
		        text .f.piControl.$host.t0 -width 80 -height 12
		        		
				grid .f.piControl.$host -column 0 -row $hostRow
				
				incr hostRow
				
				grid .f.piControl.$host.circle -column 0 -row 0
		        grid .f.piControl.$host.h1 -column 1 -row 0 
		        grid .f.piControl.$host.h2 -column 2 -row 0
		        grid .f.piControl.$host.h3 -column 3 -row 0	
		        grid .f.piControl.$host.h4 -column 4 -row 0
		        grid .f.piControl.$host.h5 -column 5 -row 0			
		        grid .f.piControl.$host.h6 -column 6 -row 0			
		        grid .f.piControl.$host.t0 -column 0 -row 1 -columnspan 7    	
		        proc outputParser$host {cmdOutput host} {
					.f.piControl.$host.t0 insert end "$cmdOutput\n"
				}
		}

}


proc send_cmd { theCommand theOutputHandler host } {
  global f
  set f [ open "| $theCommand |& cat" "r+"]
  fileevent $f readable "doThis $theOutputHandler $host"
}

proc ping { host } {
    .f.piControl.$host.t0 delete 1.0 end
    .f.piControl.$host.circle itemconfig t2$host -extent 359
    update idletask
   	set theCmd "ping -c 1 $host"
    send_cmd $theCmd outputParser$host $host
#    .f.piControl.$host.circle itemconfig t2$host -extent 0    
#	update idletask
}

proc updateStatus { host } {
    .f.piControl.$host.t0 delete 1.0 end
	set theCmd "ssh marc@$host \"sudo systemctl status\""
    send_cmd $theCmd outputParser$host $host
    .f.piControl.$host.circle itemconfig t2$host -extent 0    
	update idletask

}


proc restartWifi { host } {
    .f.piControl.$host.t0 delete 1.0 end
	#set theCmd "ssh marc@$host \"/home/marc/bin/restartWifi\""
    #send_cmd $theCmd outputParser$host $host	
    .f.piControl.$host.t0 insert end "System $host is restarting Wifi.\n"
}

proc restartKodi { host } {
    .f.piControl.$host.t0 delete 1.0 end
	set theCmd "ssh marc@$host \"sudo systemctl restart kodi.service\""
    send_cmd $theCmd outputParser$host $host	
    .f.piControl.$host.t0 insert end "System $host is restarting Kodi.\n"
}

proc restartSys { host } {
    .f.piControl.$host.t0 delete 1.0 end
	set theCmd "ssh marc@$host \"sudo reboot\""
    send_cmd $theCmd outputParser$host $host	
    .f.piControl.$host.t0 insert end "System $host is rebooting.\n"
}

proc shutdownSys { host } {
    .f.piControl.$host.t0 delete 1.0 end
	set theCmd "ssh marc@$host \"sudo shutdown now\""
    send_cmd $theCmd outputParser$host $host	
    .f.piControl.$host.t0 insert end "System $host is shutting down.\n"
}

proc mount { host } {
	set theCmd "lxterminal --command \"bin/mount.sh\""
    send_cmd $theCmd outputParser$host $host
    #mountStatus vader2
}

proc umount { host } {
	set theCmd "lxterminal --command \"bin/umount.sh\""
    send_cmd $theCmd outputParser$host $host	
    #mountStatus vader2
}

proc mountStatus { host } {
	set theCmd "cat /proc/mounts | grep wdElements"
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
