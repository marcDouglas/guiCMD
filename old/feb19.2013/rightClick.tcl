
package require Tk

proc popupMenu {theMenu theX theY} {
	set x [expr [winfo rootx .]+$theX]
	set y [expr [winfo rooty .]+$theY]
	tk_popup $theMenu $x $y
}


menu .menu -tearoff 0
.menu add command -label "Copy"
.menu add command -label "Paste"


bind . <3> {popupMenu .menu %x %y}
