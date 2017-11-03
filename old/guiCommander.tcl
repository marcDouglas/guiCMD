#!/usr/bin/wish

package require Tk
tk appname "guiCommander"



#local of wmctrl
set wmctrl "/usr/bin/wmctrl"
#default action
set action "-l"

proc screen {} {
  frame .top -borderwidth 10
  pack .top -fill x
  
  button .top.listWindows -text "Refresh" -command refreshList
  
  radiobutton .top.refresh -text "list windows" -variable mode -value refresh
  radiobutton .top.listDesktops  -text "list desktops" -variable mode -value listDesktops
  
  button .top.fullscreen -text "full screen" -command {screenModify fullscreen}
  
  #radiobutton .top.restart -text "full screen" -variable mode -value fullscreen
  #button .top.submit -text execute -command redirect 
  pack .top.listWindows .top.refresh .top.listDesktops .top.fullscreen -side left -padx 0p -pady 0 -anchor n
  frame .bottom
  pack .bottom -fill x
  text .bottom.main -relief sunken -bd 2 -yscrollcommand ".bottom.scroll set"
  scrollbar .bottom.scroll -command ".bottom.main yview"
  pack .bottom.main -side left -fill y
  pack .bottom.scroll -side right -fill y
}

proc send_command {clearScreen} {
  global action wmctrl 
  if {$clearScreen} {
    .bottom.main delete 0.0 end
  }
  set f [ open "| $wmctrl $action" r]
  while {[gets $f x] >= 0} {
    if [parseInput $x] { 
      .bottom.main insert 1.0 "$x\n"
    }
    
  }
  catch {close $f}
}

proc parseInput {inputX} {
  if {[regexp -nocase {0x[a-f0-9]{8}} $inputX matched]} {
      # Success
      puts "parseFound: $matched"
      
      #split by arbitrary number white spaces
      set wordList [regexp -inline -all -- {\S+} $inputX]
      
      #set records [split $inputX " "]
      puts "rLength: [llength $wordList]"
      set i 0
      foreach rec $wordList {
        #puts "rec: $i-$rec"
        switch $i {
          "0" {
            #set $hexWindowRep $rec
            puts "rec0 $i window Hex: $rec"
          }
          "1" {
            
            
            
            if {$rec == -1} {
             # return 0
            }
            puts "rec1 $i desktop number: $rec"
          }
          "2" {
            puts "rec2 $i client machine name: $rec"
          }
          "3" {
            puts "rec3 $i window title: $rec"
          }
          default {
            puts "$i $rec"
          }
        }
        set i [expr "$i + 1"]
      }
      return 1
    } else {
      puts "no window found"
      return 0
      # Fail
     
  }
}

proc refreshList {} {
    global action mode
    switch $mode {
        listDesktops  {set action "-d"}
        default  {set action "-l"}
  }
    send_command 1
}

proc screenModify {screenOptions} {
  global action
  switch $screenOptions {
    fullscreen  {
        set theRange [.bottom.main tag ranges sel]  

        set theWindowName [.bottom.main get [lindex $theRange 0] [lindex $theRange end]]
    #   puts "name: $theWindowName sel: $oneRange - $twoRange"
        #set action "-i -r $theWindowName -b toggle,fullscreen"
        if {[regexp -nocase {0x[a-f0-9]{8}} $theWindowName matched]} {
            # Success
            puts "success $matched"
            set action "-i -r $matched -b toggle,fullscreen"
        } else {
            puts "no window selected"
            return
            # Fail
        }
        }
    default  {return}
  }
    send_command 0
}


proc menuCreator {} {
     #  Create the main menu bar with a Help-About entry
     menu .menubar
     
     menu .menubar.file -tearoff 0
     
     .menubar add cascade -label "File" -menu .menubar.file -underline 0
     .menubar.file add command -label "Exit" \
          -accelerator "Alt-Q" -underline 0 \
          -command shutdown     

     menu .menubar.help -tearoff 0          
     .menubar add cascade -label "Help" -menu .menubar.help -underline 0
     .menubar.help add command -label "About guiCommander ..." \
          -accelerator "F1" -underline 0 \
          -command showAbout

     #  Define a procedure - an action for Help-About

     #  Configure the main window
     wm title . "guiCommander"
     . configure -menu .menubar -width 200 -height 150
     bind . "<Key F1>" {showAbout}
     bind . "<Alt-Key-q>" {shutdown}
}
proc showAbout {} {
    tk_messageBox -message "guiCommander 0.0" \
             -title "About guiCommander"
}

proc shutdown {} {
	exit
}




#load default screen
screen

menuCreator
#refresh window 
send_command 1
