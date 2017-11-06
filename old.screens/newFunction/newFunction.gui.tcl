proc newFunction_initialize { } {
        #frame .newFunction
        #grid .newFunction -column 0 -row 22       
        button .f.newFunction.h1 -text "newFrame b1" -command "screenM_requested newFunction"
        button .f.newFunction.h2 -text "jiggy 2" -command "screenM_requested newFunction"
        grid .f.newFunction.h1 -column 0 -row 0 
        grid .f.newFunction.h2 -column 1 -row 0
}


