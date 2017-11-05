proc initialize_conky_optionsTab {} {
        puts initialize_conky_optionsTab
        
        labelframe .f.conky.notebook.f1.otherFrame -text "other"
        checkbutton .f.conky.notebook.f1.otherFrame.cForkBackground -text "background" -variable cBackground -command "checkBoxChanged background"
        
        checkbutton .f.conky.notebook.f1.otherFrame.cOwnWindow -text "own_window" -variable cOwnWindow -command "checkBoxChanged own_window"        
        
        checkbutton .f.conky.notebook.f1.otherFrame.cWindowTransparent -text "window_transparent " -variable cWindowTransparent -command "checkBoxChanged own_window_transparent"
        

        checkbutton .f.conky.notebook.f1.otherFrame.cDoubleBuffer -text "double_buffer" -variable cDoubleBuffer -command "checkBoxChanged double_buffer"
        checkbutton .f.conky.notebook.f1.otherFrame.cDrawShades -text "draw_shades " -variable cDrawShades -command "checkBoxChanged draw_shades"
           
        checkbutton .f.conky.notebook.f1.otherFrame.cDrawOutline -text "draw_outline" -variable cDrawOutline -command "checkBoxChanged draw_outline"
        checkbutton .f.conky.notebook.f1.otherFrame.cDrawBorders -text "draw_borders" -variable cDrawBorders -command "checkBoxChanged draw_borders"
        checkbutton .f.conky.notebook.f1.otherFrame.cDrawGraphBorders -text "draw_graph_borders" -variable cDrawGraphBorders -command "checkBoxChanged draw_graph_borders"
        checkbutton .f.conky.notebook.f1.otherFrame.cNoBuffers -text "no_buffers " -variable cNoBuffers -command "checkBoxChanged no_buffers"

        checkbutton .f.conky.notebook.f1.otherFrame.cUpperCase -text "uppercase" -variable cUpperCase  -command "checkBoxChanged uppercase"
        checkbutton .f.conky.notebook.f1.otherFrame.cOverrideUTF8 -text "override_UTF8_locale" -variable cOverrideUTF8 -command "checkBoxChanged override_utf8_locale"
        
        labelframe .f.conky.notebook.f1.ownWindowType -borderwidth 5 -width 150 -height 200 -text "own window type"
        ttk::combobox .f.conky.notebook.f1.ownWindowType.comboBox -textvariable ozCity -state readonly \
        -values [list desktop]
        
        labelframe .f.conky.notebook.f1.windowHints -borderwidth 5 -width 150 -height 200 -text "window hints"
        #labelframe .f.conky.notebook.f1.windowHints -text "window hints" -padx 2 -pady 2
        
        checkbutton .f.conky.notebook.f1.windowHints.undecorated -text "undecorated" -variable cUndecorated -command "changeWindowHints undecorated"
        checkbutton .f.conky.notebook.f1.windowHints.below -text "below" -variable cBelow -command "changeWindowHints below"
        checkbutton .f.conky.notebook.f1.windowHints.sticky -text "sticky" -variable cSticky -command "changeWindowHints sticky"
        checkbutton .f.conky.notebook.f1.windowHints.skip_taskbar -text "skip_taskbar" -variable cSkipTaskbar  -command "changeWindowHints skip_taskbar"
        checkbutton .f.conky.notebook.f1.windowHints.skip_pager -text "skip_pager" -variable cSkipPager -command "changeWindowHints skip_pager"
    
        labelframe .f.conky.notebook.f1.defaultColors -borderwidth 2 -width 150 -height 200 -text "default Colors"
        button .f.conky.notebook.f1.defaultColors.text -text "text color" -command "changeColor default_color"
        label .f.conky.notebook.f1.defaultColors.textLabel -text "text color"
        button .f.conky.notebook.f1.defaultColors.shade -text "shade color" -command "changeColor default_shade_color"
        label .f.conky.notebook.f1.defaultColors.shadeLabel -text "text color"
        button .f.conky.notebook.f1.defaultColors.outline -text "outline color" -command "changeColor default_outline_color"
        label .f.conky.notebook.f1.defaultColors.outlineLabel -text "text color"
        
        labelframe .f.conky.notebook.f1.dimensions -borderwidth 2 -text "dimensions"
        labelframe .f.conky.notebook.f1.dimensions.gap -borderwidth 5 -width 150 -height 200 -text "gap"
        spinbox .f.conky.notebook.f1.dimensions.gap.gap_x -from -10000 -to 10000 -width 5 -validate key \
	-vcmd {string is integer %P}        
        label .f.conky.notebook.f1.dimensions.gap.xLabel -text "x"
        spinbox .f.conky.notebook.f1.dimensions.gap.gap_y -from -10000 -to 10000 -width 5 -validate key \
	-vcmd {string is integer %P}
        label .f.conky.notebook.f1.dimensions.gap.yLabel -text "y"
        

    
        labelframe .f.conky.notebook.f1.dimensions.widths  -borderwidth 5 -width 150 -height 200 -text "width"
        spinbox .f.conky.notebook.f1.dimensions.widths.maximum_width -from 0 -to 9999 -width 4 -validate key \
	-vcmd {string is integer %P} 
            label .f.conky.notebook.f1.dimensions.widths.max -text "max"
        spinbox .f.conky.notebook.f1.dimensions.widths.minimum_sizeX -from 1 -to 1000 -width 4 -validate key \
	-vcmd {string is integer %P}
            label .f.conky.notebook.f1.dimensions.widths.minmin -text "min-min"
        spinbox .f.conky.notebook.f1.dimensions.widths.minimum_sizeY -from 1 -to 1000 -width 4 -validate key \
	-vcmd {string is integer %P}
            label .f.conky.notebook.f1.dimensions.widths.minmax -text "min-max"
    
         labelframe .f.conky.notebook.f1.cpuStuff -borderwidth 2 -text "process related"
         labelframe .f.conky.notebook.f1.cpuStuff.cpuFrame  -borderwidth 5 -width 150 -height 200 -text "cpu avg samples"
        spinbox .f.conky.notebook.f1.cpuStuff.cpuFrame.cpu_avg_samples -from 0 -to 9999 -width 4 -validate key \
	-vcmd {string is integer %P}           
        labelframe .f.conky.notebook.f1.cpuStuff.update_interval  -borderwidth 5 -width 150 -height 200 -text "update_interval"
        spinbox .f.conky.notebook.f1.cpuStuff.update_interval.update_interval -from 0 -to 3 -increment .5 -format %05.2f -width 10
        labelframe .f.conky.notebook.f1.cpuStuff.total_run_times  -borderwidth 5 -width 150 -height 200 -text "total run times"
        spinbox .f.conky.notebook.f1.cpuStuff.total_run_times.total_run_times -from 0 -to 10000 -width 6 -validate key -vcmd {string is integer %P}

        
         labelframe .f.conky.notebook.f1.font  -width 150 -height 200 -text "font"
         spinbox .f.conky.notebook.f1.font.size -from 1 -to 10000 -width 4 -validate key \
	-vcmd {string is integer %P}
         button .f.conky.notebook.f1.font.font -text "change font" -command "changeFont"
        checkbutton .f.conky.notebook.f1.font.xft -text "use_xft" -variable cXft -command "checkBoxChanged use_xft" 
        spinbox .f.conky.notebook.f1.font.xftalpha -from -1 -to 1 -increment .1 -format %01.2f -width 4
        label .f.conky.notebook.f1.font.xftalphaLabel -text "alpha"
        
        button .f.conky.notebook.f1.apply -text Apply -command "conkyWriteChanges"        
        button .f.conky.notebook.f1.constantUpdating -text "Auto-Apply" -command "autoApply"
        

        
        grid .f.conky.notebook.f1.constantUpdating -column 2 -row 8        
        grid .f.conky.notebook.f1.apply -column 2 -row 7
        grid .f.conky.notebook.f1.constantUpdating -column 2 -row 8
        
        grid .f.conky.notebook.f1.font -column 0 -row 0 -rowspan 2 -sticky w
        grid .f.conky.notebook.f1.font.size  -column 0 -row 1 
        grid .f.conky.notebook.f1.font.font  -column 0 -row 2
        grid .f.conky.notebook.f1.font.xft -column 0 -row 0 -sticky w
        grid .f.conky.notebook.f1.font.xftalpha -column 0 -row 3 -sticky w
        grid .f.conky.notebook.f1.font.xftalphaLabel -column 1 -row 3 -stick w

        
        grid .f.conky.notebook.f1.defaultColors -column 0 -row 4 -rowspan 3 -sticky w
        grid .f.conky.notebook.f1.defaultColors.text -column 0 -row 0 -sticky w
        grid .f.conky.notebook.f1.defaultColors.shade -column 0 -row 1 -sticky w
        grid .f.conky.notebook.f1.defaultColors.outline -column 0 -row 2 -sticky w
        #grid .f.conky.notebook.f1.defaultColors.textLabel -column 1 -row 0
        #grid .f.conky.notebook.f1.defaultColors.shadeLabel -column 1 -row 1
        #grid .f.conky.notebook.f1.defaultColors.outlineLabel -column 1 -row 2

        
        grid .f.conky.notebook.f1.otherFrame -column 2 -row 0
        grid .f.conky.notebook.f1.otherFrame.cForkBackground -column 0 -row 0 -sticky w
        grid .f.conky.notebook.f1.otherFrame.cOwnWindow -column 0 -row 1 -sticky w
        grid .f.conky.notebook.f1.otherFrame.cWindowTransparent -column 0 -row 2 -sticky w
        grid .f.conky.notebook.f1.otherFrame.cDoubleBuffer -column 0 -row 3 -sticky w
        grid .f.conky.notebook.f1.otherFrame.cDrawShades -column 0 -row 4 -sticky w
        grid .f.conky.notebook.f1.otherFrame.cDrawOutline -column  1 -row 0 -sticky w
        grid .f.conky.notebook.f1.otherFrame.cDrawBorders -column 1 -row 1 -sticky w
        grid .f.conky.notebook.f1.otherFrame.cDrawGraphBorders -column 1 -row 2 -sticky w
        grid .f.conky.notebook.f1.otherFrame.cNoBuffers -column 1 -row 3 -sticky w
        grid .f.conky.notebook.f1.otherFrame.cUpperCase -column 1 -row 4 -sticky w
        grid .f.conky.notebook.f1.otherFrame.cOverrideUTF8 -column 1 -row 5 -sticky w        
        
        #grid .f.conky.notebook.f1.ownWindowType -column 0 -row 6 -sticky w
       # grid .f.conky.notebook.f1.ownWindowType.comboBox -column 0 -row 0 -sticky w
                


        grid .f.conky.notebook.f1.windowHints -column 1 -row 0 -sticky w -rowspan 5
        grid .f.conky.notebook.f1.windowHints.undecorated -column 0 -row 0 -sticky w
        grid .f.conky.notebook.f1.windowHints.below -column 0 -row 1 -sticky w
        grid .f.conky.notebook.f1.windowHints.sticky -column 0 -row 2 -sticky w
        grid .f.conky.notebook.f1.windowHints.skip_taskbar -column 0 -row 3 -sticky w
        grid .f.conky.notebook.f1.windowHints.skip_pager  -column 0 -row 4 -sticky w

        grid .f.conky.notebook.f1.dimensions -column 1 -row 5 
        grid .f.conky.notebook.f1.dimensions.gap -column 0 -row 7 -rowspan 2 -columnspan 2 -sticky w
        grid .f.conky.notebook.f1.dimensions.gap.gap_x -column 1 -row 0 -sticky w
        grid .f.conky.notebook.f1.dimensions.gap.xLabel -column 0 -row 0 -sticky w
        grid .f.conky.notebook.f1.dimensions.gap.gap_y -column 1 -row 1 -sticky w
        grid .f.conky.notebook.f1.dimensions.gap.yLabel -column 0 -row 1 -sticky w
        

        
        grid .f.conky.notebook.f1.dimensions.widths -column 1 -row  4 -rowspan 3 -columnspan 2 -sticky w   
        grid .f.conky.notebook.f1.dimensions.widths.maximum_width  -column 0 -row 0 -sticky w
        grid .f.conky.notebook.f1.dimensions.widths.max -column 1 -row 0 -sticky w
        grid .f.conky.notebook.f1.dimensions.widths.minimum_sizeX  -column 0 -row 1 -sticky w
        grid .f.conky.notebook.f1.dimensions.widths.minmin -column 1 -row 1 -sticky w
        grid .f.conky.notebook.f1.dimensions.widths.minimum_sizeY  -column 0 -row 2 -sticky w
        grid .f.conky.notebook.f1.dimensions.widths.minmax -column 1 -row 2 -sticky w
        
        
        grid .f.conky.notebook.f1.cpuStuff -column 2 -row 5 -sticky w
        grid .f.conky.notebook.f1.cpuStuff.cpuFrame -column 0 -row 0 -sticky w        
        grid .f.conky.notebook.f1.cpuStuff.cpuFrame.cpu_avg_samples -column 0 -row 0 -sticky w
        grid .f.conky.notebook.f1.cpuStuff.update_interval -column 0 -row  1 -sticky w
        grid .f.conky.notebook.f1.cpuStuff.update_interval.update_interval  -column 0 -row 0 -sticky w
        grid .f.conky.notebook.f1.cpuStuff.total_run_times -column 0 -row  2 -sticky w
        grid .f.conky.notebook.f1.cpuStuff.total_run_times.total_run_times  -column 0 -row 0 -sticky w
}
