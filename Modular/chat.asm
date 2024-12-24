PUBLIC terminateChat
PUBLIC chat
PUBLIC player1
PUBLIC player2

.MODEL small
.STACK 100h
.data
char db ?
value db ?

player1   db 'You $'
player2   db 'Player 2$'

terminateChat db 0
column_sender db 0  ;saves last column written in sender  [0-79]
row_sender db 1    ;saves last row written in sender  [1-11]

column_receiver db 0 ;saves last column written in receiver  [0-79]
row_receiver db 13   ;saves last row written in receiver  [13-24]

.code


Main proc
    mov ax, @data
    mov ds, ax

ChatLoop:
    call chat
    cmp terminateChat,1
    jnz ChatLoop   
    
    mov ah, 4ch
    int 21h 

Main endp



scroll_window_up proc
    push ax
    push bx
    push cx
    push dx

    mov ah, 06h           ; Function: Scroll window up
    mov al, 01h           ; Scroll up by 1 line (00h to clear the window)
    mov bh, 07h           ; Attribute for blank lines (07h = white on black) can set for color
    mov ch, 1             ; Top row of the window (1)       i.e Y1
    mov cl, 0             ; Left column of the window (0)   i.e X1
    mov dh, 10            ; Bottom row of the window (10)   i.e Y2
    mov dl, 79            ; Right column of the window (79) i.e X2
    int 10h               ; Call BIOS interrupt

    pop dx
    pop cx
    pop bx
    pop ax
    ret
scroll_window_up endp

scroll_window_up_receiver proc
            push ax
            push bx
            push cx
            push dx
            
            mov ah, 06h           ; Function: Scroll window up
            mov al, 01h           ; Scroll up by 1 line (00h to clear the window)
            mov bh, 07h           ; Attribute for blank lines (07h = white on black) can set for color
            mov ch, 13            ; Top row of the window (13)       i.e Y1
            mov cl, 0             ; Left column of the window (0)   i.e X1
            mov dh, 23            ; Bottom row of the window (23)   i.e Y2
            mov dl, 79            ; Right column of the window (79) i.e X2
            int 10h               ; Call BIOS interrupt

            pop dx
            pop cx
            pop bx
            pop ax
            ret
scroll_window_up_receiver endp

movcurserSender proc far
    push ax
    push bx
    push cx
    push dx

    ; Check if column_sender exceeds 79
    cmp column_sender, 79
    jl nextColumn               ; if not, proceed to next column
    mov column_sender, 0        ; Reset column to 0
    inc row_sender              ; Move to the next row

    ; Check if row_sender exceeds 10
    cmp row_sender, 10
    jle skip_scroll             ; If within limits, skip scrolling
    call scroll_window_up       ; Scroll up
    mov row_sender, 10          ; Keep cursor on the last allowed row

skip_scroll:
nextColumn:
    inc column_sender           ; Increment column 

    ; Update cursor position
    mov ah, 2
    mov dh, row_sender
    mov dl, column_sender
    int 10h                     ; BIOS interrupt to update cursor position

    pop dx
    pop cx
    pop bx
    pop ax
    ret
movcurserSender endp


moveCursorReceiver proc far
    push ax
    push bx
    push cx
    push dx

    ; Set cursor position using BIOS interrupt 10h, function 2
    mov ah, 2
    mov dl, column_receiver
    mov dh, row_receiver
    int 10h

    ; Check if column_receiver exceeds 79
    cmp column_receiver, 79
    jl nextColumn_rec          ; If not, proceed to next column
    mov column_receiver, 0     ; Reset column to 0
    inc row_receiver           ; Move to the next row

    ; Check if row_receiver exceeds 24
    cmp row_receiver, 23
    jle skip_scroll_recev          ; If within limits, skip scrolling
    call scroll_window_up_receiver ; Scroll up
    mov row_receiver, 23       ; Keep cursor at the last allowed row

skip_scroll_recev:
nextColumn_rec:
    inc column_receiver         ; Increment column for normal flow

    ; Update cursor position with BIOS interrupt
    mov ah, 2
    mov dh, row_receiver
    mov dl, column_receiver
    int 10h                     ; Update hardware cursor

    pop dx
    pop cx
    pop bx
    pop ax
    ret
moveCursorReceiver endp


chat proc far

            push ax
            push bx
            push cx
            push dx

            mov ah,01h         ; check if key is pressed
            mov al,0
            Int 16h
            cmp al,0h
            jz CHK            ; if no key is pressed go check if there is sth to be recieved 
                              ; else flag is set to 1 if a key presses

            mov ah,0h         ;read the char 
            Int 16h

            mov char, al
           
            cmp al,0Dh                  ;to see if it is enter
            jz EnterChar

            call movcurserSender
            ;print char to be sent
            mov ah,9
            mov bh,0 
            mov cx,1
            mov bl,0ah
            int 10h 
            jmp SkipEnter
EnterChar: 
            cmp row_sender, 10
            jz SkipEnter
            inc row_sender
            mov column_sender, 0  

SkipEnter:                      

                                        ;Check that Transmitter Holding Register is Empty
            mov dx , 3FDH		        ; Line Status Register
    AGAIN:  
            In al , dx 			        ;Read Line Status
            AND al , 00100000b          ;this exact bit tells me wether the reg is ready to send or not (add a char or abit to send) 
            JZ AGAIN

                                        ;If empty put the VALUE in Transmit data register
            mov dx , 3F8H		        ; Transmit data register (sending data)
            mov al,char
            out dx , al 
         
            cmp al,1Bh                  ;to see if it is esc
            jz termChat


                                        ;RECIEVE SECTION        
                                        ;Check that Data Ready from UART
    CHK:    mov dx , 3FDH		; Line Status Register
    	    in al , dx 
            AND al , 1
            JZ skipchat     ; if there is not char in uart go check for key pressed

           ;If Ready read the VALUE in Receive data register
            mov dx , 03F8H
            in al , dx 
            mov value , al


            cmp al,1Bh     ;if recieved char is esc terminate connection
            jz termChat
            
            cmp al,0Dh                  ;to see if it is enter
            jz EnterCharReceiver

           call moveCursorReceiver

            mov ah,9
            mov bh,0 
            mov cx,1
            mov bl,09h
            int 10h 
            jmp skipchat

EnterCharReceiver:
            cmp row_receiver, 23
            jz skipchat
            inc row_receiver
            mov column_receiver, 0            

            jmp skipchat       ;to not terminate the connection
termChat:
            mov terminateChat,1 
            mov column_sender, 0
            mov row_sender, 1

            mov column_receiver, 0
            mov row_receiver, 13      
skipchat:   
            pop dx
            pop cx
            pop bx
            pop ax
            ret

chat endp

end Main