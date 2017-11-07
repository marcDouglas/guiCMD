#!/usr/bin/tclsh

#package require Thread
proc mpd_Client {host port} {
    set s [socket $host $port]
    fconfigure $s -buffering line
    return $s
}

proc sendTo_mpd { } {
    set m [mpd_Client localhost 6600]
    puts $m "pause\n"
}

        proc mpdSync_Server {port} {
            global echo_server_state
            set echo_server_state go
            set s [socket -server mpdSyncAccept $port]
            vwait echo_server_state
            close $s
            guiTextInsert_mpd "mpdSync Server has exited."
        }
        proc mpdSyncAccept {sock addr port} {
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
            sendTo_mpd
        }

proc start_mpdSync_Server { } {
    #set id [thread::create {
        puts "mpdSync Server has started on port 8887."

        mpdSync_Server 8887
         vwait forever
       # thread::wait

   # }] ;# thread::create   set pid [fork]

}

start_mpdSync_Server
