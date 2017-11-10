#!/usr/bin/tclsh


        array set prismClients []
        array set mpdClients []
        set clientCount 0
#############################1111111111111111111111
        proc prism_Server {port} {
            global prism_server
            global runPrismServer
            set runPrismServer 1
            while { $runPrismServer == 1 } {
                set prism_server [socket -server prism_Accept $port]
                vwait prism_server
            }
        }        
##########################2222222222222222222222222
        proc prism_Accept {sock addr port } {
            global prismClients
            global clientCount
            incr clientCount
            set prismClients($clientCount) $sock
            
            #set prismSock $sock
            # Record the client's information
        
            puts "Clients Connected:$clientCount- $sock"
            #set connectedServers(addr,$sock) [list $addr $port]
                    
            fconfigure $prismClients($clientCount) -buffering line
                    
            fileevent $prismClients($clientCount) readable [list prism_receive $prismClients($clientCount) $clientCount]

            mpd_connect $clientCount
        }
##################44444444444444444444444444
        proc mpd_Client {host port} {
            set sock [socket $host $port]
            fconfigure $sock -buffering line
            return $sock
        }
################333333333333333333333333333        
        proc mpd_connect { i } {
            global mpdClients
            set mpdClients($i) [mpd_Client localhost 6600]
            #puts "receiving initial from mpd"
            #mpd_receive $mpdClients($i)  $i
            #mpd_receive $mpdSock
            #puts "done"
            #mpd_Server_receive $mpdSock
            fileevent $mpdClients($i) readable [list mpd_receive $mpdClients($i) $i]
        }
###############5555555555555555555555555
        proc mpd_receive {sock i} {
            if {[eof $sock] || [catch {gets $sock line}]} {
                puts "mpd_receive. Closing $sock"
                close $sock
            } else {                
                prism_write $line $i
            }
            
        } ;#end proc prism_server reply
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

        } ;#end proc prism_Server_receive
################  6666666666666666666666666     
        proc prism_write { cmd i } {
            global prismClients
            #puts $prismClients($i)
            if { [llength $cmd] < -1 } {
                puts "prism_write, NIL"
                return
            }
            if {[info exists prismClients($i) ]} {
                #puts "prism_write exists"
            } else {
                puts "prism_write.$i is dead, returning."
                return
                #no connection, we do no initiate, could clean up.
            }
            
            
            if { [catch { puts $prismClients($i) "$cmd" } ]} {
                #close $prismSock
                #unset prismSock
                puts "prism_write failed"
            } else {
                puts "prism write '$i-$cmd'"
            }
                

        }

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
                mpd_connect
            }
            if { [catch { puts $mpdClients($i) $cmd } ]} {
                puts "mpd_write failed, closing $i connection"
                #close $mpdSock
                #unset mpdSock
            } else {
                puts "mpd write '$i-$cmd'"
                
            }
            
        }


  
        prism_Server 6601

