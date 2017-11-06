#convertVideoForRockBox.gui.tcl
package require Tk
package require tooltip


proc progressCircle {} \
  {
  # build
  canvas .f.convertVideoForRockBox.circle -width 50 -height 50 -highlightt 0
  
  .f.convertVideoForRockBox.circle create oval 2 2 48 48 -tags t1 -fill green -outline ""
  .f.convertVideoForRockBox.circle create arc 2 2 48 48 -tags t2 -fill red -extent 0 -outline ""
  .f.convertVideoForRockBox.circle create text 25 25 -tags t3
  grid .f.convertVideoForRockBox.circle -column 0 -row 5

  }
  
proc progressCircleUpdate {percent} \
  { 
    .f.convertVideoForRockBox.circle itemconfig t3 -text $percent%
    .f.convertVideoForRockBox.circle itemconfig t2 -extent [expr {round((100-$percent) * 3.6)}]
    
  }

proc convertVideoForRockBox_initialize { } {

        global duration -1
        #frame .convertVideoForRockBox
        #grid  .convertVideoForRockBox -column 0 -row 22       

        label .f.convertVideoForRockBox.inputDirLabel -text "input Dir"
        label .f.convertVideoForRockBox.outputDirLabel -text "output Dir"
        label .f.convertVideoForRockBox.inputFileLabel -text "input filename"
        label .f.convertVideoForRockBox.outputFileLabel -text "output file"
        
        entry .f.convertVideoForRockBox.inputDir -width 45
        entry .f.convertVideoForRockBox.outputDir -width 45
        entry .f.convertVideoForRockBox.inputFile -width 60
        entry .f.convertVideoForRockBox.outputFile -width 45
        entry .f.convertVideoForRockBox.scale -width 10
        
        button .f.convertVideoForRockBox.h1 -text "Start" -command "startFFMPEG"
        button .f.convertVideoForRockBox.h2 -text "testCircle" -command "testProgressCircle"
        button .f.convertVideoForRockBox.openFile -text "select file..." -command "fileOpen"
        
        grid .f.convertVideoForRockBox.inputFileLabel -column 0 -row 0 -columnspan 3
        grid .f.convertVideoForRockBox.inputFile -column 0 -row 1 -columnspan 3 -sticky w

        grid .f.convertVideoForRockBox.inputDirLabel -column 0 -row 2 -sticky e
        grid .f.convertVideoForRockBox.inputDir -column 1 -row 2 -sticky w
        
        grid .f.convertVideoForRockBox.outputDirLabel -column 0 -row 3 -sticky e
        grid .f.convertVideoForRockBox.outputDir -column 1 -row 3 -sticky w
        
        grid .f.convertVideoForRockBox.scale -column 3 -row 4
        grid .f.convertVideoForRockBox.outputFileLabel -column 0 -row 4 -sticky e
        grid .f.convertVideoForRockBox.outputFile -column 1 -row 4 -sticky w
        
        grid .f.convertVideoForRockBox.openFile -column 3 -row 1
        grid .f.convertVideoForRockBox.h1 -column 3 -row 5
        grid .f.convertVideoForRockBox.h2 -column 1 -row 5
        progressCircle

        .f.convertVideoForRockBox.inputDir insert end "/zLake/media/video/"
        .f.convertVideoForRockBox.outputDir insert end "/ocean/mediaLibrary/videos.converted/"
        .f.convertVideoForRockBox.inputFile insert end ""
        #.f.convertVideoForRockBox.outputFile insert end "DBZ - 176 - Saving The Earth.mpeg"
        .f.convertVideoForRockBox.scale insert end "320x240"
        
}

proc startFFMPEG { } \
  {
    global duration
    set duration -1
    set inputDir [.f.convertVideoForRockBox.inputDir get]
    set inputFile [.f.convertVideoForRockBox.inputFile get]
    set outputDir [.f.convertVideoForRockBox.outputDir get]
    #set outputFile [.f.convertVideoForRockBox.outputFile get]
    set scale [.f.convertVideoForRockBox.scale get]

    
    set fileNameSplit [split $inputFile "."]
    set lastItem [lindex $fileNameSplit [expr [llength $fileNameSplit] -1]]
    set extensionIndex [expr [llength $fileNameSplit] -1]
    if { $extensionIndex >  0} \
    {
      set fileNameSplit [lreplace $fileNameSplit $extensionIndex $extensionIndex "mpeg"]
    } else {
      lappend fileNameSplit "mpeg"
    }
    
    set outputFile [join $fileNameSplit "."]
    set cmd_for_ffmpeg "ffmpeg -i \"$inputDir$inputFile\" -loglevel repeat+ -s $scale -vcodec mpeg2video -b:v 400k -ab 192k -ac 2 -ar 44100 -acodec mp3 -r 23.97 -strict 2 \"$outputDir$outputFile\""
    send_cmd $cmd_for_ffmpeg convertVideoForRockBox_parser
  }

#proc testProgressCircle {} \
  #{
  
  #for {set i 0} {$i <= 100} {incr i} \
    #{
      #progressCircleUpdate $i
      #after 100
      #update
    #}
  #}


proc doThis { theOutputHandler } {
  global f
  if { [eof $f] } {
    catch [close $f]
    global duration
    set duration -1
    #puts "EOF reached"
  } else {
        while {[gets $f rawOutput] >= 0} {
            $theOutputHandler $rawOutput
        }        
  }
    #puts "finished doThis"
}

proc send_cmd { theCommand theOutputHandler} {
  global f
  set f [ open "| $theCommand |& cat" "r+"]
  fileevent $f readable "doThis $theOutputHandler"
}


proc convertVideoForRockBox_parser { rawOutput } {

    global duration
    global f
    #puts "raw:$rawOutput\<\<"

    if { $duration < 0 } \
    {
      set splitItems [split $rawOutput ":"]
        if { [lindex $splitItems 0] == "  Duration" } \
        {
            set hours [scan [string range [lindex $splitItems 1] 1 2] %d]

            set minutes [scan [lindex $splitItems 2] %d]

            set seconds [scan [string range [lindex $splitItems 3] 0 4] %d]

            #puts "i found it - ($hours) ($minutes) ($seconds)"
            set totalSeconds [expr "$seconds + $minutes * 60 + $hours * 60 * 60"]
            #puts "totalSeconds:$totalSeconds"
            set duration $totalSeconds
        }
    } else {
      set splitItems [split $rawOutput "="]
      set isTime [string last "time" [lindex $splitItems 4]]
      if { $isTime != -1 } {
        set splitItems [split [lindex $splitItems 5] ":"]
        set pHours [scan [lindex $splitItems 0] %d]
        set pMinutes [scan [lindex $splitItems 1] %d]
        set pSeconds [scan [string range [lindex $splitItems 2] 0 4] %d]
        set pTotalSeconds [expr $pSeconds + $pMinutes * 60 + $pHours * 60 * 60]
        set percentage [expr "double($pTotalSeconds) / $duration * 100"]
        set roundP [expr {round($percentage)}]
        #puts "pTime - ($pHours) ($pMinutes) ($pSeconds) = $pTotalSeconds %($roundP - $percentage)"

 
        progressCircleUpdate $roundP
        update idletask

    }
    #puts "finished convertVideoForRockBox_parser"
}


}
proc fileOpen {} {
    set types {
        {{Video Files}      {.m4v .mp4 .flv .mpeg .avi .mkv}        }
        {{All Files}        *             }
    }
    
    set filename [tk_getOpenFile -filetypes $types -initialdir [.f.convertVideoForRockBox.inputDir get] -initialfile [.f.convertVideoForRockBox.inputFile get]]
    
    if {$filename ne ""} {
        # Open the file ...
        .f.convertVideoForRockBox.inputFile delete 0 end
        .f.convertVideoForRockBox.inputDir delete 0 end
        .f.convertVideoForRockBox.inputFile insert end "[file tail $filename]"
        .f.convertVideoForRockBox.inputDir insert end "[file dirname $filename]/"
        
    }
}
