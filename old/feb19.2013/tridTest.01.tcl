package require Tk

proc play val {
    upvar $val current
    set colours {red green yellow blue}
    incr current
    set current [expr $current % [llength $colours]]
    return [lindex $colours $current]
}

set chess 0
label .res -text result -background [play chess]
grid .res - - -sticky news
set rowz {1 2 3 4 br 6 7 8 9 * 0 #}
set rn 0
foreach {a b c} $rowz {
    incr rn
    label .a$rn -text $a -background [play chess]
    label .b$rn -text $b -background [play chess]
    label .c$rn -text $c -background [play chess]
    grid .a$rn .b$rn .c$rn -sticky news
}
grid rowconfigure . {0 1 2 3 4} -weight 1 -minsize 40
grid columnconfigure . {0 1 2} -weight 1 -minsize 40


