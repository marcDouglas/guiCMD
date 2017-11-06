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


proc mpdController_initialize { } {
    labelframe .f.mpdController.localhost -text "localhost" -width 600 -height 100
    #labelframe .f.syncDrives.localhost -text "localhost" -width 600 -height 100
    
    button .f.mpdController.localhost.h1 -text "Client" -command "start_Echo_Client"
    button .f.mpdController.localhost.h2 -text "Stop Server" -command "stop_Echo_Server"
    
    text .f.mpdController.localhost.t0 -width 80 -height 24
    canvas .f.mpdController.localhost.circle -width 25 -height 25 -highlightt 0
    .f.mpdController.localhost.circle create oval 2 2 24 24 -tags t1 -fill green -outline ""
    .f.mpdController.localhost.circle create arc 2 2 24 24 -tags t2 -fill red -extent 359 -outline ""
    #.f.mpdController.localhost.circle itemconfig t2 -extent 180
    text .f.mpdController.localhost.statusText -width 40 -height 1
    
    grid .f.mpdController.localhost -column 0 -row 0
    grid .f.mpdController.localhost.h1 -column 0 -row 1
    grid .f.mpdController.localhost.h2 -column 1 -row 1
    #grid .f.mpdController.localhost.h3 -column 2 -row 1
    grid .f.mpdController.localhost.circle -column 0 -row 0
    grid .f.mpdController.localhost.statusText -column 1 -row 0
    # grid .f.mpdController.localhost.m0 -column 3 -row 0
    grid .f.mpdController.localhost.t0 -column 0 -row 2 -columnspan 3
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



