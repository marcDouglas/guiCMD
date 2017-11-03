if {[regexp -nocase {0x[a-f0-9]{8}} $theWindowName matched]} {
    set action "-i -r $matched -b toggle,fullscreen"
} else {
    puts "no window selected"
    return
    # Fail
}
