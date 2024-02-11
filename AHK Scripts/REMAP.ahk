; ----------------------------------------------------------------------------------------------------

; A cool AHK script to make your life easier.

; Press Win+R, then run "shell:startup" to open the Startup folder. 
; Place a shortcut to this script in the Startup folder to run automatically at startup.

; Remapping: https://www.autohotkey.com/docs/v2/misc/Remap.htm
; Triple custom hotkey: https://www.autohotkey.com/docs/v2/howto/WriteHotkeys.htm#Custom_Combinations
; Hotkey modifiers: https://www.autohotkey.com/docs/v2/Hotkeys.htm#Symbols

; ----------------------------------------------------------------------------------------------------

#Requires AutoHotkey v2.0

;* Remappings
CapsLock::RCtrl                 ; Ctrl commands made easier
RAlt::Home                      ; Jump cursor to start of the line
RCtrl::End                      ; Jump cursor to end of the line

;* Hotkeys
#s::Send "#+s"                  ; Take screenshot

; Navigation (hold Rshift)
RShift & e::Send "{Up}"         ; Move cursor up
RShift & d::Send "{Down}"       ; Move cursor down
RShift & s::Send "{Left}"       ; Move cursor left
RShift & f::Send "{Right}"      ; Move cursor right

                                ; Go to the previous word
RShift & w::Send "{Ctrl Down}{Left}{Ctrl Up}" 
                                ; Go to the next word
RShift & r::Send "{Ctrl Down}{Right}{Ctrl Up}"

RShift & g::Send "{Home}"       ; Alternate Key for Home
RShift & a::Send "{End}"        ; Alternate Key for End

RShift & x::Send "{Esc}"        ; Escape selection/suggestion

; Cursor jumps
RShift & <::Send "{Alt down}{Left}{Alt Up}"
RShift & >::Send "{Alt down}{Right}{Alt Up}"

; Simulate Scroll
LinesPerScroll := 3             ; Set this accordingly
RShift & t::Send "{WheelUp}{Up " LinesPerScroll "}"
RShift & b::Send "{WheelDown}{Down " LinesPerScroll "}"

;* Deletion
RShift & v::Send "{BackSpace}"  ; Delete previous character
RShift & c::Send "{Delete}"     ; Delete next character

; hold RCtrl (capslock)
#HotIf GetKeyState("Ctrl")
                                ; Delete previous word
    RShift & v::Send "{Ctrl Down}{BackSpace}{Ctrl Up}"

                                ; Delete next word
    RShift & c::Send "{Ctrl Down}{Delete}{Ctrl Up}"

#HotIf

;* Selection and Capitalization 
RShift & z::CapsLock            ; Toggle Capslock

; hold RCtrl (capslock)
#HotIf GetKeyState("RCtrl")
                                ; Select to previous character
    RShift & s::Send "{Shift Down}{Left}{Shift Up}"

                                ; Select to previous word
    RShift & w::Send "{Shift Down}{Ctrl Down}{Left}{Ctrl Up}{Shift Up}"

                                ; Select to next character
    RShift & f::Send "{Shift Down}{Right}{Shift Up}"

                                ; Select to next word
    RShift & r::Send "{Shift Down}{Ctrl Down}{Right}{Ctrl Up}{Shift Up}"

                                ; Select to line above
    RShift & e::Send "{Shift Down}{Up}{Shift Up}"

                                ; Select to line below
    RShift & d::Send "{Shift Down}{Down}{Shift Up}"

                                ; Select to the Start of line
    RShift & g::Send "{Shift Down}{Home}{Shift Up}"

                                ; Select to the End of line
    RShift & a::Send "{Shift Down}{End}{Shift Up}"

#HotIf

;* Deselect text
; just move left or right to deselect text
; the cursor lands where the selection starts/ends

;* Unused Keys, need revision
Rshift & q::Send "{Alt Down}{Tab}{Alt Up}"

; ----------------------------------------------------------------------------------------------------

; Rough Notes: (for deletion)

; keys work really weird

; if you hold a, then tap b, a will halt. result: aaaab
; if you hold a, then b. result: aaaaabbbbbb
; u can hold a and b at the same time, but only the last one inputs as text

; Check Hotkeys, and Hotstrings, and Wildcards(*)
; Timers: https://www.autohotkey.com/docs/v2/lib/SetTimer.htm

; Check(every 50 ms) if shift is held down
; SetTimer UntoggleShift, 50
; UntoggleShift()
; {
;     if !GetKeyState("Shift", 'P') 
;         Send "{Shift Up}"        ; causes problems with #s Hotkey, bad solution
; }

; ----------------------------------------------------------------------------------------------------