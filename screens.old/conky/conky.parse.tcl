  proc conkyParse { } {
        global splitConky taggedConky conkyArray matchList
        
        set rawConky [rawConky_value]
        
        puts "conkyParse:$rawConky"
        
        variable cBackground 
        variable cXft
        variable cOwnWindow
        variable cWindowTransparent
        variable cWindowType
        variable cWindowHints
        variable cDoubleBuffer
        variable cDrawShades
        variable cDrawOutline
        variable cDrawBorders
        variable cDrawGraphBorders
        variable cNoBuffers
        variable cUpperCase
        variable cOverrideUTF8
        variable cUndecorated
        variable cBelow
        variable cSticky
        variable cSkipTaskbar
        variable cSkipPager
        set lineByline [split $rawConky "\n"]
        foreach line $lineByline {
            foreach matchItem $matchList {
                if  { [ lsearch $line $matchItem ]  == 0 } {
                    
                    set theSplit [split $line]
                    set item1 [lindex $theSplit 0]
                    set item2 [lindex $theSplit 1]
                    
                    set "conkyArray($item1)" $item2
                    
                    switch $item1 {
                      "background" { if { $item2 } { set cBackground 1 } else { set cBackground 0 } }
                        "use_xft" { if { $item2 } { set cXft 1 } else { set cXft 0 } }
                        "own_window" { if { $item2 } { set cOwnWindow 1 } else { set cOwnWindow 0 }}
                        "own_window_transparent" { if { $item2 } { set cWindowTransparent 1 } else { set cWindowTransparent 0 }}
                        "double_buffer" { if { $item2 } { set cDoubleBuffer 1 } else { set cDoubleBuffer 0 } }
                        "draw_shades" { if { $item2 } { set cDrawShades 1 } else { set cDrawShades 0 } }
                        "draw_outline" { if { $item2 } { set cDrawOutline 1 } else { set cDrawOutline 0 } }
                        "draw_borders" { if { $item2 } { set cDrawBorders 1 } else { set cDrawBorders 0 } } 
                        "draw_graph_borders" { if { $item2 } { set cDrawGraphBorders 1 } else { set cDrawGraphBorders 0 } }
                        "no_buffers" { if { $item2 } { set cNoBuffers 1 } else { set cNoBuffers 0 } }
                        "uppercase" { if { $item2 } { set cUpperCase 1 } else { set cUpperCase 0 } }
                        "override_utf8_locale" { if { $item2 } { set cOverrideUTF8 1 } else { set cOverrideUTF8 0 } }
                        "own_window_hints" { set lilSplit [split $item2 ","]
                            foreach lilItem $lilSplit {
                                switch $lilItem {
                                        "undecorated" { set cUndecorated 1 }
                                        "below" { set cBelow 1 }
                                        "sticky" { set cSticky 1 }
                                        "skip_taskbar" { set cSkipTaskbar 1 }
                                        "skip_pager" { set cSkipPager 1 }
                                }
                            } 
                        }
                        "default_color" {
                                #default 
                            
                            }
                        "default_shade_color" {
                    
                            
                            }
                        "default_outline_color" {
                            
                            
                            }
                        "gap_x" {
                                #puts "gap_x"
                                #.f.conky.notebook.f1.gap.gap_x
                        }
                        "gap_y" {
                            #.f.conky.notebook.f1.gap.gap_y
                        }
                        "cpu_avg_samples" {
                            #.f.conky.notebook.f1.cpuFrame.cpu_avg_samples
                        }
                        "update_interval" {
                            #.f.conky.notebook.f1.update_interval.update_interval
                        }
                        "minimum_size" {
                                puts "minsizeX:$item2 minsizeY:[lindex $theSplit 2]"
                                set "conkyArray($item1)" "$item2 [lindex $theSplit 2]"
                                #.f.conky.notebook.f1.widths.minimum_sizeX
                                #.f.conky.notebook.f1.widths.minimum_sizeY
                        }
                        "maximum_width" {
                                #.f.conky.notebook.f1.widths.maximum_width
                        
                        }
                        "total_run_times" {
                            #.f.conky.notebook.f1.total_run_times.total_run_times
                        }
                        "xftalpha" {
                                #puts "xftalpha $item2"
                                #.f.conky.notebook.f1.xftalpha.xftalpha
                        }
                        "xftfont" {
                            set item2 "$item2 [lrange $theSplit 2 end]"
                            set "conkyArray($item1)" $item2
                            #puts "item2: $item2"
                            set lilSplit [split $item2 ":"]
                            set theFont [lindex $lilSplit 0]
                            set size1 [lindex $lilSplit  1]
                            #puts "size1 $size1"
                            set lilSplit [split $size1 "="]
                            set theSize [lindex $lilSplit 1]
                            #puts "xftfont: -$theFont- size: -$theSize-"
                        }
                        
                        
                        default {  }  
                        }
                    
                    #puts "conkyArray $conkyArray($item1) : item: $item1"
                }
            }             
        }
   }


proc checkBoxChanged { witch } { 
    global conkyArray
    switch $witch {
                      "background" { 
                            if { $conkyArray(background) } {
                                set conkyArray(background) no
                            } else {
                                set conkyArray(background) yes
                            }

                        }
                        "use_xft" {
                            if { $conkyArray(use_xft) } {
                                set conkyArray(use_xft) no
                            } else {
                                set conkyArray(use_xft) yes
                            }    
                            puts hi                    
                        }
                        "own_window" {
                            if { $conkyArray(own_window) } {
                                set conkyArray(own_window) no
                            } else {
                                set conkyArray(own_window) yes
                            }      
                        }
                        "own_window_transparent" {
                            if { $conkyArray(own_window_transparent) } {
                                set conkyArray(own_window_transparent) no
                            } else {
                                set conkyArray(own_window_transparent) yes
                            }    
                        }                    
                        "double_buffer" {
                            if { $conkyArray(double_buffer) } {
                                set conkyArray(double_buffer) no
                            } else {
                                set conkyArray(double_buffer) yes
                            }      
                        }
                        "draw_shades" {
                            if { $conkyArray(draw_shades) } {
                                set conkyArray(draw_shades) no
                            } else {
                                set conkyArray(draw_shades) yes
                            }      
                        }                        
                        "draw_outline" {
                            if { $conkyArray(draw_outline) } {
                                set conkyArray(draw_outline) no
                            } else {
                                set conkyArray(draw_outline) yes
                            }    
                        }                        
                        "draw_borders" {
                            if { $conkyArray(draw_borders) } {
                                set conkyArray(draw_borders) no
                            } else {
                                set conkyArray(draw_borders) yes
                            }    
                        }
                        "draw_graph_borders" {
                            if { $conkyArray(draw_graph_borders) } {
                                set conkyArray(draw_graph_borders) no
                            } else {
                                set conkyArray(draw_graph_borders) yes
                            }    
                        }                                           
                        "no_buffers" {
                            if { $conkyArray(no_buffers) } {
                                set conkyArray(no_buffers) no
                            } else {
                                set conkyArray(no_buffers) yes
                            }        
                        }
                        "uppercase" {
                            if { $conkyArray(uppercase) } {
                                set conkyArray(uppercase) no
                            } else {
                                set conkyArray(uppercase) yes
                            }      
                        }                                                
                        "override_utf8_locale" {
                            if { $conkyArray(override_utf8_locale) } {
                                set conkyArray(override_utf8_locale) no
                            } else {
                                set conkyArray(override_utf8_locale) yes
                            }      
                        }                        

                        "default_color" {
                            
                            
                            }
                        "default_shade_color" {
                            
                            
                            }
                        "default_outline_color" {
                            
                            
                            }
                        "gap_x" {
                                #puts "gap_x"
                                #spinbox .f.conky.notebook.f1.gap.gap_x -value 5
                        }
                        "gap_y" {
                            
                        }
                        "cpu_avg_samples" {
                        
                        }
                        "update_interval" {
                            
                        }
                        "own_window_type" {
                                
                        }
                        
                        default {  }  
                        }
        checkAutoApply
        
}
