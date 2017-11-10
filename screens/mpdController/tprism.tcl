#!/usr/bin/tclsh


set listener_port 6601
socket -server accept_client $listener_port

proc accept_client {chan addr port} {
  global clientChan
  set clientChan $chan
  fileevent $chan readable [list handle_client $chan]
  
}

proc handle_client {chan} {
  #global client_state
  if {[eof $chan]} {
    close $chan
    #unset client_state($chan)
    return
  }
  #array set state $client_state($chan)
  if {[catch {gets $chan line}]} {
       # puts "handle_input closing $chan. ERROR READING LINE"
        #close $sock
    } else {                
        write_mpd $chan $line
    }
}

proc write_mpd { chan line } {
    global mpd_chan
    if {[info exists mpd_chan]} {
    } else {
        set mpd_chan [socket localhost 6600]
        fconfigure $mpd_chan -buffering line
        fileevent $mpd_chan readable [list receive_mpd $chan $mpd_chan]
    }
    puts $mpd_chan $line
        
}

proc receive_mpd { chan mpd_chan } {      
    global clientChan     
    if {[eof $mpd_chan] || [catch {gets $mpd_chan line}]} {
        puts "receive_mpd. Closing $sock"
        close $chan_mpd
    } else {                
        puts $chan $line
    }
}

 vwait forever
           
