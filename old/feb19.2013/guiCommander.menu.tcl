proc menuCreator {} {
     #  Create the main menu bar with a Help-About entry
     menu .menubar
     
     menu .menubar.file -tearoff 0
     
     .menubar add cascade -label "File" -menu .menubar.file -underline 0
     .menubar.file add command -label "wmctrl" \
          -accelerator "Alt-M" -underline 0 \
          -command wmctrl_requested    
     .menubar.file add command -label "newFunction" \
          -accelerator "Alt-N" -underline 0 \
          -command newFunction_requested    
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

menuCreator
