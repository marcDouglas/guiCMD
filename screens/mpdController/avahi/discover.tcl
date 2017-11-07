#!/usr/bin/tclsh
#package require Tk

proc outputParse {cmdOutput} {
    global hosts
    global interfaces
    global ipAddresses
    global ports

  set split [split $cmdOutput ";"]
  set tempHost [lindex $split 3]
  set tempInterface [lindex $split 1]
  set tempProtocol [lindex $split 2]
  set tempIP [lindex $split 7]
  set tempPort [lindex $split 8]
  #puts $split
  #puts [llength $split]

  if { [llength $split] < 8 } {   #kick out the local stuff to get ip address
      set found 1
      return
  }
  if { [regexp -nocase $tempProtocol "IPv6" matched] } {   #kick out the IPv6
      set found 1
      return
  }
  #########################################
  set found 0
  set i 0
  foreach host $hosts {

       if  { [regexp -nocase $host $tempHost matched] } {
           if { [regexp -nocase [lindex $interfaces $i] $tempInterface matched] } {
                set found 1
                #puts "duplicate: $tempHost"
                return
           }
       } 
    incr i
  }
##############################################  

  if { $found == 0 } {
    lappend hosts $tempHost
    lappend interfaces $tempInterface
    lappend ipAddresses $tempIP
    lappend ports $tempPort
    puts "host: $tempHost\[$tempInterface\] $tempIP:$tempPort"
    }
}



proc doThis { theOutputHandler } {
  global f
  if { [eof $f] } {
	if {[catch {close $f}]} {
		$theOutputHandler "nil"
        puts "finished"
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

proc send_cmd { theCommand theOutputHandler } {
  global f
  set f [ open "| $theCommand |& cat" "r+"]
  fileevent $f readable "doThis $theOutputHandler"
}

proc discoveryAvahi { } {
    global hosts
    global interfaces
    global ipAddresses
    global ports
    set hosts {}
    set interfaces {}
    set ipAddresses {}
    set ports {}
   	set theCmd "avahi-browse -trp _mpdSync._tcp"
    send_cmd $theCmd outputParse
    #setting this to 5 worked, but was bare minimum.  50 seems fast enough, and plenty of headroom
    after 50 set end 1
    vwait end
}

#puts "discoveryAvahi Starting.."
#discoveryAvahi
