#!/usr/bin/tclsh

#package require Thread
proc mpd_Client {host port} {
    set s [socket $host $port]
    fconfigure $s -buffering line
    return $s
}

proc sendTo_mpd { cmd } {
    set m [mpd_Client localhost 6600]
    puts $m $cmd
}


#######################Sync Server procs##########################

proc mpdSync_Server_reply {sock} {
    global connectedServers

    # Check end of file or abnormal connection drop,
    # then connectedServers data back to the client.

    if {[eof $sock] || [catch {gets $sock line}]} {
        puts "Close $connectedServers(addr,$sock)"
        close $sock
        unset connectedServers(addr,$sock)
    } else {
        if { [catch { puts $sock $line } ]} {
            puts "Client\[$sock\] dropped."
            close $sock
            unset connectedServers(addr,$sock)
        } else {
            puts "Client\[$sock\] \'$line\'"
        }
    }
    sendTo_mpd $line
}

proc mpdSync_Server_Accept {sock addr port} {
    global connectedServers

    # Record the client's information

    puts "Accept $sock from $addr port $port"
    set connectedServers(addr,$sock) [list $addr $port]

    # Ensure that each "puts" by the server
    # results in a network transmission

    fconfigure $sock -buffering line

    # Set up a callback for when the client sends data

    fileevent $sock readable [list mpdSync_Server_reply $sock]
}
proc mpdSync_Server {port} {
    global mpdSync_Server_state
    set mpdSync_Server_state go
    set s [socket -server mpdSync_Server_Accept $port]
    vwait mpdSync_Server_state
    close $s
}

proc start_mpdSync_Server { } {
        puts "mpdSync Server has started on port 8887."
        mpdSync_Server 8887
        vwait forever

}
#################################################################
start_mpdSync_Server
