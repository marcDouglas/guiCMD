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

global syncHosts
array set syncHosts []
array set syncClients []
global okqueue
set okqueue ""    
    
proc mpdController_initialize { } {

    labelframe .f.mpdController.localhost -text "localhost" -width 600 -height 100
    #labelframe .f.syncDrives.localhost -text "localhost" -width 600 -height 100
    
    button .f.mpdController.localhost.h1 -text "sync" -command "connectClients"
    #set cmd "list album group albumartist"
    button .f.mpdController.localhost.h2 -text "discovery" -command "findServersAvahi"
    button .f.mpdController.localhost.h3 -text "mpdServer:pause" -command "sendTo_mpd_Server2 play"
    button .f.mpdController.localhost.h4 -text "multipause" -command "syncHostSend pause"

    text .f.mpdController.localhost.t0 -width 80 -height 12
    canvas .f.mpdController.localhost.circle -width 25 -height 25 -highlightt 0
    .f.mpdController.localhost.circle create oval 2 2 24 24 -tags t1 -fill green -outline ""
    .f.mpdController.localhost.circle create arc 2 2 24 24 -tags t2 -fill red -extent 359 -outline ""
    #.f.mpdController.localhost.circle itemconfig t2 -extent 180
    text .f.mpdController.localhost.statusText -width 20 -height 1
    
    grid .f.mpdController.localhost -column 0 -row 0
    grid .f.mpdController.localhost.h1 -column 0 -row 1
    grid .f.mpdController.localhost.h2 -column 1 -row 1
    grid .f.mpdController.localhost.h3 -column 2 -row 1
    grid .f.mpdController.localhost.circle -column 0 -row 0
    grid .f.mpdController.localhost.statusText -column 1 -row 0
    grid .f.mpdController.localhost.h4 -column 2 -row 0
    # grid .f.mpdController.localhost.m0 -column 3 -row 0
    grid .f.mpdController.localhost.t0 -column 0 -row 5 -columnspan 3
    #start_mpdSync_Server
    #findServersAvahi
    start_prism_server 6601

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
    global hosts
    global interfaces
    global ipAddresses
    global ports
    global hostCheckButton

    set i 0
    if {[info exists hosts]} {
        foreach host $hosts {
            destroy .f.mpdController.localhost.clients$i
            incr i
        }
    }
    
    discoveryAvahi
    
   # guiTextInsert_mpd $hosts
   # guiTextInsert_mpd $ipAddresses
    
    
    
    set i 0
    set row 2
    set column 0
    foreach host $hosts {
        set tmp "$host [lindex $ipAddresses $i]"
        guiTextInsert_mpd $tmp
        if { [expr $i / 3] == 0 } {
            set column $i
        } else {
            set column [expr $i % 3 ] 
        }
        set row [expr $i / 3 + 2]
        checkbutton .f.mpdController.localhost.clients$i -text $tmp -variable hostCheckButton($i) -command [list changeClientStatus $i]
        grid .f.mpdController.localhost.clients$i -column $column -row $row
        incr i
    }
        
}

proc changeClientStatus { i } {
    global hostCheckButton
    #guiTextInsert_mpd "check $i"
    if { $hostCheckButton($i) ==  0 } {
        syncHostDisconnect $i
    } else {
        syncHostConnect $i
    }

}

proc connectClients { } {
    global hosts
    global interfaces
    global ipAddresses
    global ports  
    global hostCheckButton
    .f.mpdController.localhost.t0 delete 1.0 end  
    #clearing log file

    set i -1
    foreach host $hosts {
        incr i
        guiTextInsert_mpd "\[$hostCheckButton($i)\][lindex $ipAddresses $i] [lindex $ports $i]"
        if { $hostCheckButton($i) ==  1 } {
              set sock [syncHostConnect $i]
        } else {
            syncHostDisconnect $i
        }
    }
    
}

proc syncHostConnect { i } {
    global hosts
    global interfaces
    global ipAddresses
    global ports
    global syncHosts
    if {[info exists syncHosts($i)]} {
        guiTextInsert_mpd "already connected, returning:[lindex $hosts $i]:[lindex $ports $i]"
        return
    }
    guiTextInsert_mpd "connecting:[lindex $hosts $i]:[lindex $ports $i]"
    set sock [netClient [lindex $hosts $i] [lindex $ports $i]]
    
    if { $sock != -1 } {
        set syncHosts($i) $sock
        guiTextInsert_mpd "success talking to:[lindex $hosts $i]:[lindex $ports $i]"
    } else {
        guiTextInsert_mpd "failed to connect to:[lindex $hosts $i]:[lindex $ports $i]"
    }

    return $sock
}

proc syncHostDisconnect { i } {
    global hosts
    global interfaces
    global ipAddresses
    global ports
    global syncHosts
    if {[info exists syncHosts($i)]} {
        guiTextInsert_mpd "closing connection to:[lindex $hosts $i]:[lindex $ports $i]"
        close $syncHosts($i)
        unset syncHosts($i)
    }
}

proc syncHostSend { msg } {
    .f.mpdController.localhost.t0 delete 1.0 end
    global hosts
    global interfaces
    global ipAddresses
    global ports
    global syncHosts   
    global hostCheckButton

    foreach {i host} [array get syncHosts] {
        if { $hostCheckButton($i) ==  0 } {
            syncHostDisconnect $i
        } else {
            if { [catch { puts $host $msg } ] } {
                guiTextInsert_mpd "$host connection FAILED."
                syncHostDisconnect $i
                set host [syncHostConnect $i]
                if { [catch { puts $host $msg } ] } {
                    guiTextInsert_mpd "$host connection FAILED twice. "
                    syncHostDisconnect $i
                    set host [syncHostConnect $i]
                     if { [catch { puts $host $msg } ] } {
                        guiTextInsert_mpd "$host connection FAILED three times, setting down. "
                        syncHostDisconnect $i
                        set hostCheckButton($i) 0
                    }
                }
            }
            guiTextInsert_mpd "syncHostSend:[lindex $hosts $i]-[lindex $ipAddresses $i]:[lindex $ports $i]"
        }
    }
}


proc stop_mpdSync_Server { } {
    global mpdSync_server_state
    guiTextInsert_mpd "Stopping mpdSync Server."
    set mpdSync_server_state stop
}

proc mpdSync_Server {port} {
    global mpdSync_server_state
    set mpdSync_server_state go
    guiTextInsert_mpd "Starting Echo Server."
    set s [socket -server mpdSync_Server_Accept $port]
    vwait mpdSync_server_state
    close $s
    guiTextInsert_mpd "Echo Server has exited."

}

proc start_mpdSync_Server { } {
    set id [thread::create {
        puts "I am the Child. I start Echo Server on port 8888 now..."
        proc mpdSync_Server {port} {
            global mpdSync_server_state
            set mpdSync_server_state go
            #guiTextInsert_mpd "Starting Echo Server."
            set s [socket -server mpdSync_Server_Accept $port]
            vwait mpdSync_server_state
            close $s
            guiTextInsert_mpd "mpdSync Server has exited."
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
        proc mpdSync_Server_reply {sock} {
            global connectedServers
        
            # Check end of file or abnormal connection drop,
            # then connectedServers data back to the client.
        
            if {[eof $sock] || [catch {gets $sock line}]} {
                puts "Close $connectedServers(addr,$sock)"
                close $sock
                unset connectedServers(addr,$sock)
            } else {
                puts $sock $line
                puts "else : $sock-$line"
            }
        }
        mpdSync_Server 8888
        thread::wait

    }] ;# thread::create   set pid [fork]

}



proc netClient {host port} {
    if {[catch { set s [socket $host $port] } ]} {
        set s -1
    } else {
        fconfigure $s -buffering line
    }
    return $s
}

###################################################################3

proc sendTo_mpd_Server { } {
   # global m
    set m [netClient localhost 6600]
    
    puts $m "list album group albumartist\n"
    while {[gets $m line] >= 0} {
        #puts $line
        guiTextInsert_mpd $line
    }
    puts "finished."


}

proc sendTo_mpd_Server2 { cmd } {
    set m [netClient localhost 6600]

    puts $m "$cmd"

    while {[gets $m line] >= 0} {
        puts $line
    }


}

######################################################################

proc start_prism_server { port } {
    set id [thread::create {
##############  THREAD STARTS HERE #################
        global prismClients
        global mpdClients
        global clientCount
        array set prismClients []
        array set mpdClients []
        set clientCount 0
        
        proc prism_server { port } {
            global prismServerRoot
            global runPrismServer
            set runPrismServer 1
            while { $runPrismServer == 1 } {
                set prismServerRoot [socket -server prism_Accept $port]
                vwait runPrismServer
            }
        }        
##########################2222222222222222222222222
        proc prism_Accept { sock addr port } {
            fconfigure $sock -buffering line
            #fconfigure $sock -encoding utf-8
            #puts $sock "punk"
            
            global prismClients
            global clientCount
            incr clientCount
            set i $clientCount
            set prismClients($i) $sock
            
           # puts wtf
            #puts $sock $sock
            
            #set prismSock $sock
            # Record the client's information
        
            puts "prism_Accept:$clientCount- $sock"
            #set connectedServers(addr,$sock) [list $addr $port]
                    
           # fconfigure $prismClients($i) -buffering line
                    
            fileevent $prismClients($i) readable [list prism_receive $prismClients($i) $i]

            mpd_connect $i
        }
##################44444444444444444444444444
        proc mpd_client {host port} {
            set sock [socket $host $port]
            fconfigure $sock -buffering line
            #fconfigure $sock -encoding utf-8
            return $sock
        }
################333333333333333333333333333        
        proc mpd_connect { i } {
            global mpdClients
            set mpdClients($i) [mpd_client localhost 6600]
            
            #mpd_receive $mpdClients($i)  $i
            
            fileevent $mpdClients($i) readable [list mpd_receive $mpdClients($i) $i]
        }
###############5555555555555555555555555
        proc mpd_receive {sock i} {
            global prismClients
            global mpdClients
            if {[eof $sock] || [catch {gets $sock line}]} {
                puts "mpd_receive. Closing $sock"
                close $sock
                if { [catch {close $prismClients($i)}]} {
                    
                } else {
                    unset prismClients($i)
                }
                unset mpdClients($i)
            } else {
                #puts "mpd_receive '$line'"
                
                prism_write $line $i
            }
        } ;#end proc mpd_client reply
###########################888888888888888888
        proc mpd_write { cmd i } {
            global mpdClients
            if { [llength $cmd] < 1 } {
                puts "mpd_write, NIL"
                return
            }
            if {[info exists mpdClients($i) ]} {
                #puts "mpdSock exists"
            } else {
                mpd_connect $i
                
            }
            if { [catch { puts $mpdClients($i) $cmd } ]} {
                puts "mpd_write$i failed, closing connection"
                #close $mpdClients($i)
                #unset mpdClients($i)

                #mpd_connect $i
                #if { [catch { puts $mpdClients($i) $cmd } ]} {

                #} else {
                    #puts "2mpd$i write '$cmd'"
                #}
                
            } else {
                puts "mpd$i write '$cmd'"
                
            }
            
        }
##################7777777777777777777777777
        proc prism_receive { sock i } {
            if {[eof $sock] || [catch {gets $sock line}]} {
                puts "prism_receive. Closing $sock"
                close $sock
            } else {
                #puts $sock $line
                #puts "prism receive '$line'"
                mpd_write $line $i
            }
            
            
        } ;#end proc prism_server_receive
################  6666666666666666666666666     
        proc prism_write { cmd i } {
            global prismClients
            global okqueue
            #puts $prismClients($i)
            if { [llength $cmd] < -1 } {
                puts "prism_write, NIL"
                return
            }

            #set filterItem "OK"
            #if { [regexp -nocase "OK MPD" $cmd matched] } {
                #append cmd "\0"
            #} elseif { [regexp -nocase $filterItem $cmd matched] } {
                #append cmd "\0"
                ##append okqueue "$cmd"
                ##set cmd $okqueue
            #} else {
                #append cmd "\0"
               ## append okqueue "$cmd\n"
               ## return
            #}
            
            
            if {[info exists prismClients($i) ]} {
                #puts "prism_write exists"
            } else {
                puts "prism_write.$i is dead, returning."
                return
                #no connection, we do no initiate, could clean up.
            }
            
            #puts $prismClients($i)
            append cmd "\0"
            if { [catch { puts $prismClients($i) $cmd } ]} {
                #close $prismSock
                #unset prismSock
                puts "prism$i write failed"
            } else {
                puts "prism$i write '$cmd'"
                #set okqueue ""
            }
                

        }




  
        prism_server 6601
        thread::wait

    }] ;# thread::create   set pid [fork]
} ;#end start_mpd_client

