#!/usr/bin/tclsh



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
fconfigure $sock -blocking 0
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
fconfigure $sock -blocking 0
#fconfigure $sock -encoding utf-8
return $sock
}
################333333333333333333333333333        
proc mpd_connect { i } {
global mpdClients
set mpdClients($i) [mpd_client localhost 6600]
puts "mpd_connect:$i-"
puts $mpdClients($i)

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
#if { [expr $i % 2] == 0 } {
    #puts "mpd_write sleeping$i"
    #after 2500
#}
if { [llength $cmd] < 1 } {
    puts "mpd$i write NIL"
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

    mpd_connect $i
    if { [catch { puts $mpdClients($i) $cmd } ]} {
        
    } else {
        puts "2mpd$i write '$cmd'"
    }
    
} else {
    puts "mpd$i write '$cmd'"
    
}

#after 10


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
#global okqueue
#puts $prismClients($i)
if { [llength $cmd] < 1 } {
    puts "prism_write, NIL"
    return
}

#append cmd "\0"
set filterItem "OK"
if { [regexp -nocase "OK MPD" $cmd matched] } {
    append cmd "\0\f"
} elseif { [regexp -nocase $filterItem $cmd matched] } {
    append cmd "\0\f"
    #append okqueue "$cmd"
    #set cmd $okqueue
} else {
    append cmd "\0\f"
   # append okqueue "$cmd\n"
   # return
}


if {[info exists prismClients($i) ]} {
    #puts "prism_write exists"
} else {
    puts "prism_write.$i is dead, returning."
    return
    #no connection, we do no initiate, could clean up.
}

#puts $prismClients($i)

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


