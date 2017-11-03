proc menuCreator {} {
     #  Create the main menu bar with a Help-About entry
     menu .menubar
     
     menu .menubar.file -tearoff 0
     
     .menubar add cascade -label "File" -menu .menubar.file -underline 0
     .menubar.file add command -label "Exit" \
          -accelerator "Alt-Q" -underline 0 \
          -command shutdown     

     menu .menubar.screens -tearoff 0
     
     .menubar add cascade -label "Screens" -menu .menubar.screens -underline 0



     menu .menubar.help -tearoff 0          
     .menubar add cascade -label "Help" -menu .menubar.help -underline 0
     .menubar.help add command -label "About guiCMD ..." \
          -accelerator "F1" -underline 0 \
          -command showAbout

     #  Define a procedure - an action for Help-About

     #  Configure the main window
     wm title . "guiCMD"
     . configure -menu .menubar -width 200 -height 150
     bind . "<Key F1>" {showAbout}
     bind . "<Alt-Key-q>" {shutdown}
}
proc showAbout {} {
    tk_messageBox -message "guiCMD 0.1" \
             -title "About guiCMD"
}

proc shutdown {} {
	exit
}

menuCreator
