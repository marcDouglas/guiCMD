

proc rcCreateUI { } {
    puts "..>>^^creating UI for config^^<<.."
    global buttonKeys2 frameList cOpt0 cOpt1 cOpt2 cOpt3 rcName 
	if { [llength $buttonKeys2] != 0 } {
		clearButtons $buttonKeys2
	}

	
	set tabNum 0
	set i 0
	set row 0
	set column 0
	set nkeyPanel []
	
	set akey ".f.tintTwo.basic"
	lappend buttonKeys2 $akey
	labelframe $akey -text "$rcName"	
	grid $akey -column 0 -row 2 -columnspan 3
	
	set nkey $akey.nbook
	lappend buttonKeys2 $nkey
	ttk::notebook $nkey
	grid $nkey -column 0 -row 0 -columnspan 3
	
	foreach item $cOpt3 {
		set tName [lindex $cOpt0 $i]
		if { $tabNum <= $item } {
			if { $tabNum <= 7 } {
				if { $tabNum == 0 } {
					set nkeyPanel "$nkey.bg"
					frame $nkeyPanel; 
					$nkey add $nkeyPanel -text "backgrounds"
					#grid $nkeyPanel -column 0 -row 0
					lappend buttonKeys2 $nkeyPanel
					set ykey $nkeyPanel.tab
					lappend buttonKeys2 $ykey
					ttk::notebook $ykey
					grid $ykey -column 0 -row 0
					
				}
					set nkeyPanel "$ykey.f$tabNum"
					frame $nkeyPanel; 
					$ykey add $nkeyPanel -text "$tabNum [lindex $frameList $tabNum]"
					#grid $nkeyPanel -column 0 -row 0
					lappend buttonKeys2 $nkeyPanel
					
					#set row 0
					#set column 0
					#set bkey "$nkeyPanel.b$item$i"
	
				} else {
					#puts "..::nkey:$nkey.f$tabNum ::.."
					set nkeyPanel "$nkey.f$tabNum"
					frame $nkeyPanel; 
					$nkey add $nkeyPanel -text "$tabNum [lindex $frameList $tabNum]"
					#grid $nkeyPanel -column 0 -row 0
					lappend buttonKeys2 $nkeyPanel
					
					#set bkey "$nkeyPanel.b$item$i"
				}
				incr tabNum
				set row 0
				set column 0
				incr i
			} else {
				#puts "nkeypanel=$nkeyPanel  tName=$tName"
				puts "tabNum:$tabNum item:$item tName:$tName:1:[lindex $cOpt1 $i] 2:[lindex $cOpt2 $i] 3:[lindex $cOpt3 $i]"
				
				set bkey "$nkeyPanel.b$item$i"
				#puts "bkey=$bkey"
				
				genInputBoxes $tName $bkey $column $row $i [lindex $cOpt1 $i] [lindex $cOpt2 $i]
				lappend buttonKeys2 $bkey
				incr i
				incr row
				if { $row % 5 == 0 } {
					set row 0
					incr column
				}
			}	
		}
}

proc genInputBoxes { tName bkey column row i value1 value2} {
  	if {[string first "color" $tName] > -1} { 
		button $bkey -text "$tName \[$value1\] \[$value2\]" -command "parseButton $bkey $i"
		bind $bkey <3> "ppSlider $bkey $i Opacity $value2"
	}  elseif { [string first "rounded" $tName] > -1 ||   [string first "border_width" $tName] > -1 } {
		button $bkey -text "$tName  \[$value1\]" -command "ppSlider $bkey $i $tName $value1"
	}	elseif { [string first "autohide" $tName] > -1  ||   [string first "mouse" $tName] > -1} {
		button $bkey -text "$tName" -command "boolDialog $bkey $tName $i $value1"
	}	elseif { [string first "panel" $tName] > -1 ||   [string first "auto" $tName] > -1  ||   [string first "mouse" $tName] > -1} {
		button $bkey -text "$tName" -command "boolDialog $bkey $tName $i $value1"
	}	else { 
		button $bkey -text "$tName" -command "parseButton $bkey $i"
	}
    grid $bkey -column $column -row $row		


}

proc parseButton { bkey i } {
    global buttonKeys2 frameList cOpt0 cOpt1 cOpt2 cOpt3 rcName
    #puts "[lindex $cOpt0 $i]:[lindex $cOpt1 $i]:[lindex $cOpt2 $i]:[lindex $cOpt3 $i]"	
  	if {[string first "color" [lindex $cOpt0 $i]] > -1} {  
		set color [tk_chooseColor -initialcolor [lindex $cOpt1 $i]]
		puts "bkey:$bkey i:$i color:$color"

	}
}

proc ppSlider { window i whatFor value } {
	scale .f.slider -from 0 -to 100 -length 200 -variable pc \
	        -tickinterval 20 -orient horizontal
	.f.slider set $value
	button .f.done -text "change now" -command "ppSliderDone $window"
	button .f.cancel -text "forget it" -command "ppSliderCancel $window"	
	grid .f.slider
	grid .f.done
	grid .f.cancel	
	
}

proc boolDialog { window tName i value1 } {
	global boolValue
	label .f.boolLabel -text "$tName"
	radiobutton .f.boolRadio1 -text "Yes"   -variable boolValue -value "1"
	radiobutton .f.boolRadio0 -text "No" -variable boolValue -value "0"
	if { $value1 == 0 } {
		.f.boolRadio0 select
	} else {
		.f.boolRadio1 select
	}  
	#set boolRadioTemp .f.boolRadio$value1
	#$boolRadioTemp select
	
	button .f.done -text "change now" -command "boolDialogDone $window"
	button .f.cancel -text "forget it" -command "boolDialogCancel $window"	
	grid .f.boolLabel
	grid .f.boolRadio1
	grid .f.boolRadio0
	grid .f.done
	grid .f.cancel	   
}

proc boolDialogDone { window } {
	global boolValue
	#puts [.f.boolRadio1 get]
	puts $boolValue
	boolDialogDestroyWindows
}

proc boolDialogCancel { } {
	boolDialogDestroyWindows
}
proc boolDialogDestroyWindows { } {
	destroy .f.boolLabel
	destroy .f.boolRadio1	
	destroy .f.boolRadio0
	destroy .f.done
	destroy .f.cancel
}
proc ppSliderDone { window } {
	puts [.f.slider get]
	puts $window
	
	ppSliderDestroyWindows

}

proc ppSliderCancel { whatFor } {
	ppSliderDestroyWindows
}

proc ppSliderDestroyWindows { } {
	
	destroy .f.slider
	destroy .f.done
	destroy .f.cancel
}

proc rcCreateUIinitialize { } {
	
}

proc rcConfigButtons { configList } {
	global rcInt buttonKeys rcName
	if { $rcInt > 0 } {
		clearButtons $buttonKeys
		set rcInt 0
		puts "..::  rcConfig Buttons Reset  ::.."
   	}
	foreach rcPath $configList {
		set handle "k$rcInt"
		set rcPathSplit  [split $rcPath "/"]
		set rcName [lindex $rcPathSplit end]
		set buttonKey ".f.tintTwo.configs.cf$rcInt"
		
		button $buttonKey -text "$rcName" -command "readConfigFile $rcInt"
		
		grid $buttonKey -column $rcInt -row 0 
		
		lappend buttonKeys $buttonKey	
		
		incr rcInt
	}
}

proc clearButtons { buttonKeys } {
    #global buttonKeys
    foreach buttonKey $buttonKeys {
      destroy $buttonKey
      #puts "bKey: $buttonKey"
    }
   # wValues -reset

}
