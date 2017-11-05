


proc readTintTwoPref {} {
	global homeDir configFile tintDir
	file mkdir ~/.config/tint2/
	cd ~/.config/tint2/
	if { [ file exists tintTwo.config ] == 1 } { 
			set fp [open tintTwo.config r]
			set configFile [read $fp]
			close $fp
			cd $homeDir

	} else {
		cd $homeDir
		set configFile [list]      
	}
		
}

proc writeTintTwoPref {} {
	global homeDir configFile
	file mkdir ~/.config/tint2/
	cd ~/.config/tint2/
	set fp [open configFile w]
	puts $fp $configFile
	close $fp   
	cd $homeDir
}

