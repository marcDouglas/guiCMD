proc initialize_conky_textTab {} {
        puts initialize_conky_textTab
        #global textpad
        frame .f.conky.notebook.f2.textFrame
        set textpad .f.conky.notebook.f2.textFrame.pad
        text $textpad -yscrollcommand ".f.conky.notebook.f2.textFrame.scroll set" -setgrid true -width 85 \
	-height 25 -wrap word -highlightthickness 0 -borderwidth 0
        scrollbar .f.conky.notebook.f2.textFrame.scroll -command "$textpad yview"
        
        frame .f.conky.notebook.f2.buttonFrame
        checkbutton .f.conky.notebook.f2.buttonFrame.saveComments -text "save changes to comments" -variable saveComments -command "padCheckButtonChanged saveComments"
        button .f.conky.notebook.f2.buttonFrame.apply -text "apply" -command "padSaveChanges now"
        button .f.conky.notebook.f2.buttonFrame.autoApply -text "auto-apply" -command "padSaveChanges auto"
                
       # $textpad tag configure center -justify center -spacing1 5m -spacing3 5m

        
        grid .f.conky.notebook.f2.textFrame -column 0 -row 0 -columnspan 6 -rowspan 7
        grid $textpad -column 0 -row 0
        
        grid .f.conky.notebook.f2.buttonFrame -column 0 -row 8 -rowspan 7
        grid .f.conky.notebook.f2.buttonFrame.saveComments -column 0 -row 0 -sticky w
        grid .f.conky.notebook.f2.buttonFrame.apply -column 1 -row 0 -sticky e
        grid .f.conky.notebook.f2.buttonFrame.autoApply -column 2 -row 0 -sticky e
}

proc padSaveChanges { witch } {
    global autoApply
    switch $witch {
            "now" {
                
            }
            "auto" {
                autoApply ; #conky.tcl
            }
    }
}

proc padCheckAutoApply {} {
        global autoApply
        if { $autoApply } {
            conkyWriteChanges }
}

proc textSearch {w string tag} {
    $w tag remove search 0.0 end
    if {$string == ""} {
        return
    }
    set cur 1.0
    while 1 {
        set cur [$w search -count length $string $cur end]
        if {$cur == ""} {
            break
        }
        $w tag add $tag $cur "$cur + $length char"
        set cur [$w index "$cur + $length char"]
    }
}

#button $w.string.button -text "Highlight" \
	-command "textSearch $w.text \$searchString search"

proc conkyPadParse {} {
   # global rawConky 
    set rawConky [rawConky_value]
    #puts $rawConky
    set textpad .f.conky.notebook.f2.textFrame.pad
    
    $textpad insert end $rawConky
    
    set index [$textpad search "TEXT" 1.0 end]
    puts "index:$index"    
    
    $textpad delete 1.0 $index
    $textpad delete 1.0 2.0

    #textSearch $textpad " no" noBool
    #$textpad tag configure noBool -background #ce5555 -foreground white
   
     #textSearch $textpad " yes" yesBool
    #$textpad tag configure yesBool -background green -foreground black 
      
   #if {[winfo depth $w] > 1} {
    #textToggle "$w.text tag configure search -background \
	    ##ce5555 -foreground white" 800 "$w.text tag configure \
	    #search -background {} -foreground {}" 200
#} else {
    #textToggle "$w.text tag configure search -background \
	    #black -foreground white" 800 "$w.text tag configure \
	    #search -background {} -foreground {}" 200
#}

}
