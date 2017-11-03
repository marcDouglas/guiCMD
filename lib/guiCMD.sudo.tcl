#!/usr/bin/tclsh

proc sudo:passwd {pipe} {
   puts "sudo:passwd \[$pipe\]"
   catch {puts $pipe iml}
   fileevent $pipe writable {}
}
 
proc sudo:read {pipe} {
   puts "sudo:read \[$pipe\]"
   variable $pipe
   upvar  0 $pipe _
   set chars [gets $pipe line]
   puts "  read \[$line\] ($chars chars)"
   append _(stdout) $line\n
   if { [eof $pipe] } {
      puts "  got eof"
      fileevent $pipe readable {}
      fileevent $pipe writable {}
      if { [catch {close $pipe} code] } {
         puts "  Got error closing sudo pipe"
         puts "  \[$::errorCode\] $code"
      } else {
         puts "  Successfully closed sudo pipe"
         puts "  code = \[$code\]"
      }
      set _(done) 1
   }
}
 
proc sudo:run {args} {
   set cmd [eval concat $args]
   puts "cmd = \[$cmd\]"
   set list [concat [list sudo -S] $cmd [list 2>&1]]
   puts "list = \[$list\]"
   if { [catch {open |$list r+} pipe] } {
      puts "\[$::errorCode\] $pipe"
   } else {
      puts "  open returned \[$pipe\]"
      fconfigure $pipe -buffering none -blocking 1
      fileevent  $pipe writable [list sudo:passwd $pipe]
      fileevent  $pipe readable [list sudo:read   $pipe]
   }
   variable $pipe
   upvar  0 $pipe _
   set _(done) 1
   set _(stdout) ""
   set ns [namespace current]
   if { [string equal $ns ::] } { set ns "" }
   return ${ns}::$pipe
}
 
#et sudo [sudo:run [list ls -l /root]]ls

#set sudo [sudo:run [list renice -15 13516]]ls

#vwait ${sudo}(done)
#puts "sudo = \[$sudo\]"
#upvar #0 $sudo array
#parray array
