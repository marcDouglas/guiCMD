package require Tk

frame .f
button .f.b1 -text "yippie!"
button .f.b2 -text "skippie!"
entry .f.e1
button .f.b3 -text "submit" -command submitText 
.f.e1 insert end "hello"

grid .f  -column 0 -row 0
grid .f.b1 -column 0 -row 0
grid .f.b2 -column 1 -row 0
grid .f.e1 -column 0 -row 1 -columnspan 2
grid .f.b3 -column 0 -row 2

proc submitText {} {
    set text [.f.e1 get]
    puts $text
}
