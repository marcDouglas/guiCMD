proc tparse { rcFileUnsplit rcName } {
	global frameOptions frameList cOpt0 cOpt1 cOpt2 cOpt3
	set frameList []
	set frameOptions []
	set currentFrame -1
	set cOpt0 []
	set cOpt1 []
	set cOpt2 []
	set cOpt3 []
	puts "tparse has begun on $rcName--------------\n"
	set rcFile [split $rcFileUnsplit "\n"]
	#puts "name: $rcName \n indexItem: [lindex $rcFile 55] \n $rcFile "
	foreach line $rcFile {
		#puts $line
		if {[string first ":" $line] > -1} {
			if {[string first "https://" $line] == -1} {
				if {[string first "time1" $line] == -1} {
					set frameName [split $line ":"]
					lappend frameList [lindex $frameName end]
					#puts [lindex $frameName end]
					incr currentFrame
					#puts $frameList
				} else {
					
				}
			}
		} elseif { $currentFrame >= 7 && [string first "# " $line] > -1 } {
			 set frameName [string range $line 2 end]
			 lappend frameList $frameName
			 incr currentFrame
		
		} elseif {[string first "=" $line] > -1} {
				set lineSplit [split $line " = "]
				set frameDynamicName "frame$currentFrame"
				#set temp [lindex $frameList $currentFrame]
				#puts "cF:$currentFrame:$temp"
				set frameO []
				lappend frame0 "$currentFrame" [lindex $frameList $currentFrame] [lindex $lineSplit 0] [lindex $lineSplit 3] [lindex $lineSplit 4]
				#lappend frameOptions "$currentFrame [lindex $frameList $currentFrame] [lindex $lineSplit 0] [lindex $lineSplit 3] [lindex $lineSplit 4]\n"
				lappend frameOptions $frame0
				
				lappend cOpt0 [lindex $lineSplit 0]
				lappend cOpt1 [lindex $lineSplit 3]
				lappend cOpt2 [lindex $lineSplit 4]
				lappend cOpt3 $currentFrame


			
		}
	}
	
	#puts $frameOptions
	puts "cOpt0 ##########\n$cOpt0 ############\n"
	puts "cOpt1 ##########\n$cOpt1 ############\n"
	puts "cOpt2 ##########\n$cOpt2 ############\n"
				
	puts "``````````````````````````````````tparse done."
	
	
	#set frameTag 0
	#set currentFrame 0
	#set totalFrames [llength $frameList]
	#puts "totalFrames: $totalFrames \n $frameList"	
	
	#foreach line $rcFile {
		#if {$currentFrame <= $totalFrames } {
			#if {[string first ":" $line] > -1 && [string first "https://" $line] == -1} {
				#incr currentFrame
				##set frameOptions [lindex $frameList $currentFrame]
				#set frameDynamicName "frame$currentFrame"
				#set $frameDynamicName { [lindex $lineSplit 0] [lindex $lineSplit 3] [lindex $lineSplit 4] }
				#puts "$frameDynamicName - $[lindex $frameList $currentFrame]"
			#} elseif { $currentFrame > 0 } {
				#set lineSplit [split $line " = "]
					##puts $lineSplit
					#puts "[lindex $lineSplit 0]----[lindex $lineSplit 3]--[lindex $lineSplit 4]"
					##set [lindex $frameList $currentFrame]
			#}	
		#} else {
			#if { $currentFrame > 0 } {
				##puts "$currentFrame:$line"
			#}
		#}
	#}
		
			
}

proc parseConfig {} {
	global configFile configList
	set configList [list]
	#set menuList [list]
	foreach line $configFile {
		if {[string first "tint2rc." $line] > -1} {
			lappend configList $line	
		}
	}
	rcConfigButtons $configList
}


proc parseConfig2 { index } {
	global configList rcName
	#foreach rcPath $configList {
	set rcPath [lindex $configList $index]
	set rcPathSplit  [split $rcPath "/"]
	set rcName [lindex $rcPathSplit end]
	puts "$rcPath ---- $rcName"	
	lappend menuList $rcName
	if { [ file exists $rcPath ] == 1 } {
		puts "................opening file............."
		set fp [open $rcPath r]
		set rcFile [read $fp]
		close $fp
			#puts $rcFile
		tparse $rcFile $rcName
	}
	#}	
}

