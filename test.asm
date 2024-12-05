.model small 
.stack 100h

.data
    ;Brick gifts
    PowerUp         db  0
    gift_x          dw  0
    gift_y          dw  0
    gift_dy         dw  2
    gift_size       equ 10
    gift_background db  100
    gift_speed      equ 10
    gift_counter    dw  10
    gift_color      db  2
    ribbon_color    db  4
    bow_color       db  6
.code
main PROC
    ; Set up data segment
    mov  ax, @data
    mov  ds, ax

    ; Set video mode 13h (320x200 graphics)
    mov  ah, 0
    mov  al, 13h
    int  10h

    ; Initialize gift properties
    mov  PowerUp, 1
    mainloop:
    call DrawGift
    call MoveGift
    loop mainloop
    

    ; Wait for key press
    mov  ah, 0
    int  16h

    ; Return to text mode
    mov  ah, 0
    mov  al, 03h
    int  10h

    ; Exit program
    mov  ah, 4Ch
    int  21h
main ENDP
DrawGift PROC
    ; Check if PowerUp is active
                        CMP  PowerUp, 0
                        JE   cont

                        mov  cx, [gift_x]                  ; Starting x-coordinate
                        mov  dx, [gift_y]                  ; Starting y-coordinate
                        mov  bx, [gift_size]               ; Size of the gift
                        mov  si, 0                         ; Offset for background array
    DrawRowG:           
                        push cx                            ; Save x-coordinate for the next row
                        mov  di, 0                         ; Column counter
    DrawColumnG:        
                        mov  ah, 0Dh                       ; BIOS interrupt to get pixel color
                        int  10h
                        mov  [gift_background + si], al    ; Save background pixel

                        mov  ah, 0Ch                       ; BIOS interrupt to set pixel color
                        mov  al, gift_color                ; Set gift color
                        int  10h

                        inc  cx                            ; Move to the next column
                        inc  di
                        inc  si                            ; Increment background buffer offset
                        cmp  di, bx                        ; Check if the row is complete
                        jl   DrawColumnG
                        pop  cx                            ; Restore x-coordinate for the new row
                        inc  dx                            ; Move to the next row
                        cmp  dx, [gift_y + bx]             ; Check if all rows are drawn
                        jl   DrawRowG

    ; Draw horizontal ribbon
                        mov  si, [gift_size]
                        shr  si, 1                         ; Calculate ribbon's horizontal position
                        add  dx, si
                        mov  cx, [gift_x]
                        mov  di, 0
    RibbonHorizontal:   
                        mov  ah, 0Ch
                        mov  al, ribbon_color
                        int  10h

                        inc  cx
                        inc  di
                        cmp  di, bx
                        jl   RibbonHorizontal

    ; Draw vertical ribbon
                        mov  cx, [gift_x]
                        add  cx, si
                        mov  dx, [gift_y]
                        mov  di, 0
    RibbonVertical:     
                        mov  ah, 0Ch
                        mov  al, ribbon_color
                        int  10h

                        inc  dx
                        inc  di
                        cmp  di, bx
                        jl   RibbonVertical

    ; Draw bow
                        mov  cx, [gift_x]
                        mov  dx, [gift_y]
                        mov  di, 0
    DrawBow:            
                        mov  ah, 0Ch
                        mov  al, bow_color
                        int  10h

                        inc  cx
                        inc  di
                        cmp  di, [gift_size]
                        jl   DrawBow

    cont:               
                        RET
DrawGift ENDP

MoveGift PROC
                        CMP  PowerUp, 0
                        JE   endd
                        MOV  AX, gift_y
                        ADD  AX,[gift_dy]  ; Loop to draw a filled rectangle (gift)
                        MOV  gift_y, AX
                        CMP  AX, 190
                        JL   endd
                        MOV  PowerUp, 0
    endd:           
                        RET
MoveGift endp
END main
