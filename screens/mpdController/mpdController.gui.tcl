if { [ file exists mpdController.gui.tcl ] != 1 } {
  #  source mpdController.gui.tcl
  cd screens/mpdController
}

#source mpdController.dataObject.tcl
#source ../lib/sudo.tcl
source mpdController.file.tcl
#source mpdController.parse.tcl
source ../lib/preferenceHandler.tcl
#package require Tclx
package require Thread

source avahi/discover.tcl


proc mpdController_initialize { } {
    labelframe .f.mpdController.localhost -text "localhost" -width 600 -height 100
    #labelframe .f.syncDrives.localhost -text "localhost" -width 600 -height 100
    
    button .f.mpdController.localhost.h1 -text "Client" -command "start_Echo_Client"
    #set cmd "list album group albumartist"
    button .f.mpdController.localhost.h2 -text "discovery" -command "findServersAvahi"
    button .f.mpdController.localhost.h3 -text "mpdServer:pause" -command "sendTo_mpd_Server2 pause"
   
    text .f.mpdController.localhost.t0 -width 80 -height 24
    canvas .f.mpdController.localhost.circle -width 25 -height 25 -highlightt 0
    .f.mpdController.localhost.circle create oval 2 2 24 24 -tags t1 -fill green -outline ""
    .f.mpdController.localhost.circle create arc 2 2 24 24 -tags t2 -fill red -extent 359 -outline ""
    #.f.mpdController.localhost.circle itemconfig t2 -extent 180
    text .f.mpdController.localhost.statusText -width 40 -height 1
    
    grid .f.mpdController.localhost -column 0 -row 0
    grid .f.mpdController.localhost.h1 -column 0 -row 1
    grid .f.mpdController.localhost.h2 -column 1 -row 1
    grid .f.mpdController.localhost.h3 -column 2 -row 1
    grid .f.mpdController.localhost.circle -column 0 -row 0
    grid .f.mpdController.localhost.statusText -column 1 -row 0
    # grid .f.mpdController.localhost.m0 -column 3 -row 0
    grid .f.mpdController.localhost.t0 -column 0 -row 3 -columnspan 3
    start_Echo_Server
}
proc guiTextInsert_mpd {cmdOutput} {
    #.f.syncDrives.localhost.t0 delete 1.0 end
    .f.mpdController.localhost.t0 insert end "$cmdOutput\n"
        update idletask
}

proc guiTextReplace_mpd {cmdOutput} {
    .f.mpdController.localhost.t0 delete 1.0 end
    .f.mpdController.localhost.t0 insert end "$cmdOutput\n"
}

proc findServersAvahi { } {
    discoveryAvahi
    global hosts
    global interfaces
    global ipAddresses
    global ports
    
    guiTextInsert_mpd $hosts
    guiTextInsert_mpd $ipAddresses
    
    set i 0
    foreach host $hosts {
        set tmp "$host [lindex $ipAddresses $i]"
        checkbutton .f.mpdController.localhost.clients$i -text $tmp
        grid .f.mpdController.localhost.clients$i -column $i -row 2
        incr i
    }
        
}


proc stop_Echo_Server { } {
    global echo_server_state
    guiTextInsert_mpd "Stopping Echo Server."
    set echo_server_state stop
}






# Echo_Server --
#	Open the server listening socket
#	and enter the Tcl event loop
#
# Arguments:
#	port	The server's port number




proc Echo_Server {port} {
    global echo_server_state
    set echo_server_state go
    guiTextInsert_mpd "Starting Echo Server."
    set s [socket -server EchoAccept $port]
    vwait echo_server_state
    close $s
    guiTextInsert_mpd "Echo Server has exited."

}

proc start_Echo_Server { } {
    set id [thread::create {
        puts "I am the Child. I start Echo Server on port 8888 now..."
        proc Echo_Server {port} {
            global echo_server_state
            set echo_server_state go
            #guiTextInsert_mpd "Starting Echo Server."
            set s [socket -server EchoAccept $port]
            vwait echo_server_state
            close $s
            guiTextInsert_mpd "Echo Server has exited."
        }
        proc EchoAccept {sock addr port} {
            global echo
        
            # Record the client's information
        
            puts "Accept $sock from $addr port $port"
            set echo(addr,$sock) [list $addr $port]
        
            # Ensure that each "puts" by the server
            # results in a network transmission
        
            fconfigure $sock -buffering line
        
            # Set up a callback for when the client sends data
        
            fileevent $sock readable [list Echo $sock]
        }
        proc Echo {sock} {
            global echo
        
            # Check end of file or abnormal connection drop,
            # then echo data back to the client.
        
            if {[eof $sock] || [catch {gets $sock line}]} {
                puts "Close $echo(addr,$sock)"
                close $sock
                unset echo(addr,$sock)
            } else {
                puts $sock $line
                puts "else : $sock-$line"
            }
        }
        Echo_Server 8888
        thread::wait

    }] ;# thread::create   set pid [fork]

}



proc Echo_Client {host port} {
    set s [socket $host $port]
    fconfigure $s -buffering line
    return $s
}


proc start_Echo_Client_Only_Once {} {
    global client_on_state
    global s
    if { [info exists client_on_state] } { 
        puts $s "client_on_state is TRUE."
        gets $s line
        puts $line
        return 
    } else { 
        set s [Echo_Client localhost 8888]
        set client_on_state 42
    }
}

proc start_Echo_Client { } {
    global s
    #set s [Echo_Client localhost 8888]
    start_Echo_Client_Only_Once
    
    puts $s "Hello!"
    puts $s "There!"
    puts $s "Joyful!"
    puts $s "Fellow!"

    gets $s line
    puts $line
    gets $s line
    puts $line
    gets $s line
    puts $line
    gets $s line
    puts $line
}

###################################################################3

proc sendTo_mpd_Server { } {
   # global m
    set m [Echo_Client localhost 6600]
   # start_mpd_Client_Only_Once
    
    #puts $m "pause\n"
    puts $m "list album group albumartist\n"
   # puts $m "Joyful!"
   # puts $m "Fellow!"
    while {[gets $m line] >= 0} {
        #puts $line
        guiTextInsert_mpd $line
    }
    puts "finished."
    #gets $m line
    #puts $line
    #gets $m line
    #puts $line

}

proc sendTo_mpd_Server2 { cmd } {
   # global m
    set m [Echo_Client localhost 6600]
   # start_mpd_Client_Only_Once
    
    #puts $m "pause\n"
    puts $m "$cmd\n"
   # puts $m "Joyful!"
   # puts $m "Fellow!"
    while {[gets $m line] >= 0} {
        puts $line
    }
    #gets $m line
    #puts $line
    #gets $m line
    #puts $line

}
