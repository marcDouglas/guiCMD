#source screens/conky/conky.tcl

################################################################
global rawConky
    
if [info exists rawConky] {
    puts "am solo"
} else {
    set rawConky 1 
    cd screens/conky
    source conky.tcl
}
source conky.parse.tcl
source conky.gui.textTab.tcl
source conky.gui.optionsTab.tcl
source conky.file.tcl
##################################################################


proc conky_initialize { } {
        ttk::notebook .f.conky.notebook -width 600 -height 400 
        grid .f.conky.notebook -column 0 -row 0
        .f.conky.notebook add [frame .f.conky.notebook.f2] -text "First tab"
        .f.conky.notebook add [frame .f.conky.notebook.f1] -text "Second tab"

        ttk::notebook::enableTraversal .f.conky.notebook
    
        

        initialize_conky_textTab
        initialize_conky_optionsTab
        
        conkyParse
        conkyPadParse
}


