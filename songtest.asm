.MODEL small
.STACK 100h

.DATA
; Reversed Frequencies for the notes (High to Low)
; Define Frequencies for Notes (High to Low)
C6_freq    equ 3951   ; Frequency for C6 (1046 Hz)
D6_freq    equ 3520   ; Frequency for D6 (1174 Hz)
E6_freq    equ 3136   ; Frequency for E6 (1318 Hz)
F6_freq    equ 2794   ; Frequency for F6 (1396 Hz)
G6_freq    equ 2637   ; Frequency for G6 (1568 Hz)
A6_freq    equ 2349   ; Frequency for A6 (1760 Hz)
B6_freq    equ 2093   ; Frequency for B6 (1976 Hz)
C7_freq    equ 1976   ; Frequency for C7 (2093 Hz)
D7_freq    equ 1760   ; Frequency for D7 (1760 Hz)
E7_freq    equ 1568   ; Frequency for E7 (1568 Hz)
F7_freq    equ 1396   ; Frequency for F7 (1396 Hz)
G7_freq    equ 1318   ; Frequency for G7 (1318 Hz)
A7_freq    equ 1174   ; Frequency for A7 (1174 Hz)
B7_freq    equ 1046   ; Frequency for B7 (1046 Hz)
C8_freq    equ 987    ; Frequency for C8 (4186 Hz)
D8_freq    equ 880    ; Frequency for D8 (4690 Hz)
E8_freq    equ 784    ; Frequency for E8 (5274 Hz)
F8_freq    equ 740    ; Frequency for F8 (5587 Hz)
G8_freq    equ 698    ; Frequency for G8 (6272 Hz)
A8_freq    equ 659    ; Frequency for A8 (7040 Hz)


; Song notes stored in an array
songNotes  dw D7_freq, E7_freq, F7_freq, F7_freq, E7_freq, E7_freq, F7_freq, 
            D7_freq, C7_freq, D7_freq, D7_freq, D6_freq, G6_freq, F6_freq, 
            E6_freq, D6_freq, G6_freq, A6_freq, G6_freq, F6_freq, E6_freq, 
            D6_freq, G6_freq, F6_freq, G6_freq

noteCount  equ 25 


freq       dw 0       
songPos    dw 0       

.CODE
beep proc
    push ax
    push bx
    push cx
    push dx

    mov al, 182           ; Prepare the speaker for the note
    out 43h, al           ; Output to port 43h
    mov ax, [freq]        ; Frequency number in decimal
    mov al, byte ptr [freq] ; Output low byte of frequency
    out 42h, al
    mov al, ah            ; Output high byte of frequency
    out 42h, al
    in al, 61h            ; Turn on the note (get value from port 61h)
    or al, 00000011b      ; Set bits 1 and 0
    out 61h, al           ; Send new value to port 61h

    mov bx, 3             ; Pause for duration of note (3 iterations)
pause1q:
    mov cx, 65535
pause2q:
    dec cx
    jne pause2q
    dec bx
    jne pause1q

    in al, 61h            ; Turn off the note (get value from port 61h)
    and al, 11111100b     ; Reset bits 1 and 0
    out 61h, al           ; Send new value to port 61h

    pop dx
    pop cx
    pop bx
    pop ax

    ret
beep endp

; Procedure to create a delay between notes
delay proc
    mov cx, 6000h         ; Set the delay duration (this can be adjusted)
delay_loop:
    loop delay_loop       ; Loop to create the delay
    ret
delay endp

; Procedure to play the song using an array of notes
play_song proc
    lea si, songNotes     ; Load address of song array
    mov cx, noteCount     ; Set loop counter to number of notes in song

play_loop:
push cx
    mov ax, [si]          ; Load the current note frequency from array
    mov [freq], ax        ; Store it in the freq variable
    call beep             ; Play the note
    call delay            ; Add a delay between notes
    add si, 2             ; Move to next note in the array (2 bytes per note)
    pop cx
    loop play_loop        ; Loop through all notes in the song

    ; When the song ends, restart from the beginning
    lea si, songNotes     ; Reload the address of the song array
    mov cx, noteCount     ; Set the loop counter again
    jmp play_loop         ; Jump to play the song again (without recursion)
    ret
play_song endp

; Main procedure
MAIN PROC
    MOV       AX, @DATA
    MOV       DS, AX

    ; Play the song
    CALL play_song

    ; Exit program (for DOS or similar environment)
    MOV       AX, 4C00h
    INT       21h
MAIN ENDP

END MAIN
