    package require Tk
    
proc _prefsWindow_create  { }  {
    toplevel .prefsWindow
    wm title .prefsWindow "Prefs"

    bind    .prefsWindow  <Key-KP_Enter>  {_prefsWindow_ok_button}
    bind    .prefsWindow  <Return>        {_prefsWindow_ok_button}
    bind    .prefsWindow  <Escape>        {_prefsWindow_cancel_button}
    
    wm protocol .prefsWindow WM_DELETE_WINDOW {
        _prefsWindow_cancel_button
    }
}

proc _prefsWindow_ok_button {} {
   #....saving the needed data...
   _prop_menu_cancel_button
}

proc _prefsWindow_cancel_button {} {
    destroy .prefsWindow
    # make the top window usable again
    #grab set .
    # redraw the canvas
    #nlv_draw
}

_prefsWindow_create
