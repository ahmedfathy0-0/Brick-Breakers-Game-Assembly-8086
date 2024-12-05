
.MODEL small
.STACK 100h

.DATA
    padel_x1            DW  135
    padel_x2            DW  185
    padel_y1            DW  187
    padel_y2            DW  190
    padel_color         db  4
    padel_speed         equ 7

    ball_x              DW  160
    ball_y              DW  180
    ball_dx             DW  0
    ball_dy             DW  2
    ball_og_speed       equ 2
    ball_size           equ 3
    divide_factor       equ 10
    ball_color          db  2
    difficulty          db  0
    original_difficulty db  0

    selected_level      db  0
    ;Bricks number of rows and columns
    numRows             dw  8                                                                                     ; 2 * real number of rows
    rowStart            dw  20, 35, 50, 65, 80, 95, 110, 125, 140, 155
    numCols             dw  14                                                                                    ; 2 * real number of cols
    colStart            dw  5, 50, 95, 140, 185, 230, 275, 320, 365, 410
    dummycol            dw  ?
    dummyrow            dw  ?
    ;Bricks existence
    bricks              dw  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

    ;Brick dimensions
    rwidth              dw  40
    rheight             dw  10

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;Brick gifts
    gift_dy             dw  2
    gift_size           equ 10
    gift_speed          equ 10
    gift_color          db  2
    ribbon_color        db  4
    bow_color           db  6
    gift_count          dw  5
    backgournd_color    db  5 dup(0)                                                                              ; Max number of gifts
    gift_active         db  5 dup(0)                                                                              ; 1 if gift is active, 0 otherwise
    gift_x_list         dw  5 dup(0)                                                                              ; X positions of gifts
    gift_y_list         dw  5 dup(0)                                                                              ; Y positions of gifts
    gift_counter_list   dw  5 dup(gift_speed)                                                                     ; Counters for each gift



.CODE

ClearScreen PROC
                        mov  ax, 0A000h
                        mov  es, ax
                        xor  di, di
                        mov  al, 0
                        mov  cx, 64000
                        rep  stosb
                        RET
ClearScreen ENDP

DrawPadel PROC
                        mov  cx, padel_x1
                        mov  dx, padel_y1
                        mov  al, padel_color
                        mov  ah, 0ch
    draw_top:           
                        int  10h
                        inc  cx
                        cmp  cx, padel_x2
                        jnz  draw_top

                        mov  cx, padel_x1
                        mov  dx, padel_y1
    draw_left:          
                        int  10h
                        inc  dx
                        cmp  dx, padel_y2
                        jnz  draw_left

                        mov  cx, padel_x2
                        mov  dx, padel_y1
    draw_right:         
                        int  10h
                        inc  dx
                        cmp  dx, padel_y2
                        jnz  draw_right

                        mov  cx, padel_x1
                        mov  dx, padel_y2
    draw_bottom:        
                        int  10h
                        inc  cx
                        cmp  cx, padel_x2
                        jnz  draw_bottom

                        mov  dx, padel_y1
    fill_outer:         
                        inc  dx
                        cmp  dx, padel_y2
                        jz   end_Draw

                        mov  cx, padel_x1
    fill_inner:         
                        inc  cx
                        cmp  cx, padel_x2
                        jz   fill_outer

                        mov  ah, 0ch
                        int  10h
                        jmp  fill_inner

    end_Draw:           
                        RET
DrawPadel ENDP


MovePadel PROC
                        mov  ah, 1
                        int  16h
                        jz   noKeyPressed

                        mov  ah, 0
                        int  16h

                        cmp  AL, 'd'
                        jz   MoveRight

                        cmp  AL, 'a'
                        jz   MoveLeft

    noKeyPressed:       
                        RET

    MoveRight:          
                        cmp  padel_x2, 310
                        jge  stop_move
                        mov  padel_color, 0
                        call DrawPadel
                        add  padel_x1, padel_speed
                        add  padel_x2, padel_speed
                        mov  padel_color, 4
                        RET
                     
    MoveLeft:           
                        cmp  padel_x1, 10
                        jle  stop_move
                        mov  padel_color, 0
                        call DrawPadel
                        sub  padel_x1, padel_speed
                        sub  padel_x2, padel_speed
                        mov  padel_color, 4
                        RET
    stop_move:          
                        RET

MovePadel ENDP

DrawBall PROC
		
                        MOV  CX,ball_x
                        MOV  DX,ball_y
		
    DrawBall_HORIZONTAL:
                        MOV  AH,0Ch
                        MOV  AL,ball_color
                        MOV  BH,00h
                        INT  10h
			
                        INC  CX
                        MOV  AX,CX
                        SUB  AX,ball_x
                        CMP  AX,ball_size
                        JNG  DrawBall_HORIZONTAL
			
                        MOV  CX,ball_x
                        INC  DX
			
                        MOV  AX,DX
                        SUB  AX,ball_y
                        CMP  AX,ball_size
                        JNG  DrawBall_HORIZONTAL
		
                        RET
DrawBall ENDP

    end_early:          
                        ret
MoveBall PROC
                        dec  difficulty
                        cmp  difficulty, 0
                        jne  end_early
                        mov  al, original_difficulty
                        mov  difficulty, al
                        mov  ax, ball_x
                        add  ax, ball_dx
                        mov  ball_x, ax

                        mov  ax, ball_y
                        add  ax, ball_dy
                        mov  ball_y, ax

                        cmp  ball_x, 10
                        jle  ball_left_edge

                        cmp  ball_x, 315
                        jge  ball_right_edge

                        mov  ax, ball_y
                        add  ax, ball_size
                        cmp  ax, padel_y1
                        jl   continue_move

                        mov  ax, ball_y
                        add  ax, ball_size
                        cmp  ax, padel_y2
                        jg   continue_move

                        mov  ax, ball_x
                        add  ax, ball_size
                        cmp  ax, padel_x1
                        jl   continue_move
                     
                        mov  ax, ball_x
                        add  ax, ball_size
                        cmp  ax, padel_x2
                        jg   continue_move
                        neg  ball_dy

                        mov  ax, padel_x1
                        add  ax, padel_x2
                        shr  ax, 1
                        cmp  ball_x, ax

                        jb   left_side

                        mov  bx, ball_x
                        sub  bx, ax
                        mov  cl ,3
                        shr  bx, cl
                        mov  ball_dx, bx
                        jmp  continue_move

    left_side:          

                        mov  bx, ball_x
                        sub  ax, bx
                        mov  cl, 3
                        shr  ax, cl
                        mov  ball_dx, ax
                        neg  ball_dx
                        jmp  continue_move

    ball_left_edge:     
                        neg  ball_dx
                        jmp  continue_move

    ball_right_edge:    
                        neg  ball_dx
                        jmp  continue_move

    continue_move:      
                        cmp  ball_y, 10
                        jle  ball_top_edge

                        cmp  ball_y, 190
                        jge  ball_bottom_edge

                        jmp  end_move

    ball_top_edge:      
                        neg  ball_dy
                        jmp  end_move

    ball_bottom_edge:   
                        CALL ResetAll
    end_move:           
                        RET
MoveBall ENDP

ResetAll PROC
                        mov  ball_x, 160
                        mov  ball_y, 180
                        mov  ball_dx, ball_og_speed
                        mov  ball_dy, ball_og_speed
                        mov  padel_x1, 135
                        mov  padel_x2, 185
                        mov  padel_y1, 187
                        mov  padel_y2, 190
                        CALL ClearScreen
                        cmp  selected_level, 1
                        jnz  cont1
                        CALL DrawLevel1
                        jmp  cont
    cont1:              
                        cmp  selected_level, 2
                        jnz  cont2
                        CALL DrawLevel2
                        jmp  cont
    cont2:              
                        cmp  selected_level, 3
                        CALL DrawLevel3
    cont:               
                        CALL DrawPadel
                        mov  ball_color, 2
                        CALL DrawBall
                        mov  ah, 0
                        int  16h
                        RET
ResetAll ENDP
DrawGift PROC
    ; Check if PowerUp is active
                        mov  si, bx                          ; Load gift index into SI
                        cmp  [gift_active+si], 0             ; Check if the gift is active
                        je   SkipDrawing                     ; Skip if not active


    ; Use calculated offsets to access gift_x_list and gift_y_list
                        mov  cx, [gift_x_list+bx]            ; Get X position of the gift
                        mov  dx, [gift_y_list+bx]            ; Get Y position of the gift
                        mov  bx, gift_size                   ; Load the gift size
                        push cx
                        push dx
                        mov  si, 0
    DrawColumnG:        
                        push cx
                        mov  di, 0
    DrawRowG:           
                        mov  ah, 0Ch
                        mov  al, gift_color
                        int  10h

                        inc  cx
                        inc  di
                        cmp  di, bx
                        jl   DrawRowG
                        pop  cx
                        inc  dx
                        inc  si
                        cmp  si, bx
                        jl   DrawColumnG
                        pop  dx
                        pop  cx
                        push cx
                        push dx

    ; Draw horizontal ribbon
                        mov  si, gift_size
                        shr  si, 1
                        add  dx, si
                        mov  di, 0
    RibbonHorizontal:   
                        mov  ah, 0Ch
                        mov  al, ribbon_color                ; Color for ribbon (e.g., Red)
                        int  10h

                        inc  cx
                        inc  di
                        cmp  di, bx
                        jl   RibbonHorizontal

    ; Draw vertical ribbon
                        pop  dx
                        pop  cx
                        push cx
                        push dx
                        add  cx, si
                        mov  di, 0
    RibbonVertical:     
    ; Set pixel for ribbon (Vertical)

                        mov  ah, 0Ch
                        mov  al, ribbon_color
                        int  10h

                        inc  dx
                        inc  di
                        cmp  di, bx
                        jl   RibbonVertical

    ; Draw bow (top decoration)
                        pop  dx
                        pop  cx
                        mov  di, 0
    DrawBow:            
                        mov  ah, 0Ch
                        mov  al, bow_color
                        int  10h

                        inc  cx
                        inc  di
                        cmp  di, gift_size
                        jl   DrawBow
    SkipDrawing:        

                        RET
DrawGift ENDP

MoveGift PROC
                        mov  cx, gift_count
                        xor  bx, bx

    LoopMoveGifts:      
                        cmp  bx, cx
                        jge  EndMove

    ; Calculate offset for current gift
                        mov  ax, bx
                        shl  ax, 1
                        mov  si, ax

    ; Check if gift is active
                        cmp  [gift_active+bx], 0             ; Is the gift active?
                        je   SkipGift

    ; Decrement counter
                        dec  [gift_counter_list+si]          ; Decrement gift's counter
                        jnz  SkipGift

    ; Reset counter
                        mov  ax, gift_speed
                        mov  [gift_counter_list+si], ax

    ; Move gift down
                        mov  ax, [gift_y_list+si]
                        add  ax, gift_dy
                        mov  [gift_y_list+si], ax            ; Update Y position

    ; Deactivate if out of bounds
                        cmp  ax, 190                         ; Check if gift is out of bounds
                        jl   SkipGift
                        mov  byte ptr [gift_active+bx], 0

    SkipGift:           
                        inc  bx                              ; Move to the next gift index
                        jmp  LoopMoveGifts

    EndMove:            
                        ret
MoveGift ENDP


DrawRectangle PROC
    ;to calculate final column
                        mov  dx,rowStart[di]                 ;set row start of each rectangle
                        mov  ah,0ch                          ;command to draw pixel
                         
                        mov  bx, rheight                     ; bx = height
                        add  bx, dx                          ; bx = height + row = final row to draw in
                        mov  dummyrow, bx                    ;dummyrow now holds the final row
 
    ;to calculate final column
                        mov  bx, rwidth                      ;bx = rectangle wdith
                        add  bx, colStart[si]                ;bx += column start
                        mov  dummycol, bx                    ;dummycol now has the final column to draw
        
    height_loop:                                             ;draws pixels along the height (rows)
                        mov  cx,colStart[si]

    width_loop:         int  10h                             ;draws pixels along the width (columns) for one row
                        inc  cx
                        cmp  cx, dummycol
                        jnz  width_loop
                                                 

                        inc  dx
                        cmp  dx, dummyrow
                        jnz  height_loop
                        ret
DrawRectangle ENDP

DrawRow proc
                        mov  si, 0                           ; si is col-index
                        mov  al, 0
                        mov  dl, al

    draw_loop:          
                        push ax
                        mov  ax, di
                        mov  cx, 7
                        mul  cx
                        mov  bx, ax
                        add  bx, si
                        mov  dx, ax
                        mov  dx, bricks[bx]
                        pop  ax
                        inc  al                              ;change color of each rectangle
                        cmp  dx, 1
                        jne  dont_draw
                        call DrawRectangle
    dont_draw:          
                        add  si, 2                           ; Move to the next rectangle
                        cmp  si, numCols
                        jnz  draw_loop
                        ret
DrawRow ENDP

DrawLevel1 proc
                        mov  di, 0                           ; di is row-index
                        mov  numRows, 8
                        mov  numCols, 14
                        mov  difficulty, 01fh
                        mov  original_difficulty, 01fh
                        mov  selected_level, 1
    rows_loop:          
                        call DrawRow
                        add  di,2                            ;move 2 bytes to second element
                        cmp  di, numRows
                        jnz  rows_loop
                        ret
DrawLevel1 endp

DrawLevel2 proc
                        mov  di, 0                           ; di is row-index
                        mov  numRows, 14
                        mov  numCols, 16
                        mov  rwidth, 20
                        mov  difficulty, 0dh
                        mov  original_difficulty, 0dh
                        mov  selected_level, 2


    lvl2:               
                        call DrawRow
                        add  di,2                            ;move 2 bytes to second element
                        cmp  di, numRows
                        jnz  lvl2
                        ret

DrawLevel2 endp

DrawLevel3 proc
                        mov  di, 0                           ; di is row-index
                        mov  numRows, 20
                        mov  numCols, 20
                        mov  rwidth, 10
                        mov  difficulty, 09h
                        mov  original_difficulty, 09h
                        mov  selected_level, 3

    lvl3:               
                        call DrawRow
                        add  di,2                            ;move 2 bytes to second element
                        cmp  di, numRows
                        jnz  lvl3
                        ret
DrawLevel3 endp

Collision proc
                        push ax
                        push bx
                        push cx
                        push dx
                        push di
                        push si

                        mov  di, 0                           ; di is row-index
    collision_loop1:    
                        mov  si, 0                           ; si is col-index
                        mov  ax, di
                        mov  cx, 7
                        mul  cx
                        mov  bx, ax
    collision_loop2:    
                        mov  ax, bricks[bx]
                        add  bx, 2
                        cmp  ax, 1
                        jne  no_brick
                        call CheckCollision
    no_brick:           
                        add  si, 2                           ; Move to the next rectangle
                        cmp  si, numCols
                        jne  collision_loop2

                        add  di,2                            ;move 2 bytes to second element
                        cmp  di, numRows
                        jne  collision_loop1

                        pop  si
                        pop  di
                        pop  dx
                        pop  cx
                        pop  bx
                        pop  ax
                        ret
Collision endp

CheckCollision proc
                        push ax
                        push bx
                        push cx
                        push dx

                        mov  ax, rowStart[di]
                        sub  ax, ball_size
                        cmp  ax, ball_y
                        jg   no_collision

                        add  ax, rheight
                        add  ax, ball_size
                        cmp  ax, ball_y
                        jl   no_collision

                        mov  ax, colStart[si]
                        cmp  ax, ball_x
                        jg   no_collision

                        add  ax, rwidth
                        cmp  ax, ball_x
                        jl   no_collision
                        
                        mov  ax, di
                        mov  cx, 7
                        mul  cx
                        mov  bx, ax
                        add  bx, si
                        mov  bricks[bx], 0
                        CALL beep
                        CALL ClearBrick

    no_collision:       
                        pop  dx
                        pop  cx
                        pop  bx
                        pop  ax
                        ret
CheckCollision endp

ClearBrick proc near
                        push ax
                        push bx
                        push cx
                        push dx
                        push di
                        push si

                        mov  al, 0
                        call DrawRectangle
                        CALL SpawnGift
    
                        pop  si
                        pop  di
                        pop  dx
                        pop  cx
                        pop  bx
                        pop  ax
                        ret
ClearBrick endp
SpawnGift PROC
    ; Find an inactive gift slot
                        mov  cx, gift_count                  ; Load the total number of gifts
                        xor  bx, bx                          ; BX = index of current gift

    FindSlot:           
                        cmp  bx, cx                          ; Check if all slots are checked
                        jge  NoSlotAvailable                 ; No slot available if BX >= gift_count

                        cmp  [gift_active+bx], 0             ; Check if the gift slot is inactive
                        je   ActivateGift                    ; If inactive, activate the slot
                        inc  bx                              ; Move to the next gift slot
                        jmp  FindSlot

    ActivateGift:       
    ; Calculate offset for the current gift slot
                        mov  ax, bx                          ; Load BX (gift index) into AX
                        shl  ax, 1                           ; Multiply BX by 2 (shift left by 1)
                        mov  si, ax                          ; Store result in SI (offset)

    ; Activate gift and set initial position
                        mov  byte ptr [gift_active+bx], 1    ; Mark the slot as active
                        mov  ax, ball_x                      ; Example spawn X position
                        mov  [gift_x_list+si], ax            ; Set X position
                        mov  ax, ball_y                      ; Example spawn Y position
                        mov  [gift_y_list+si], ax            ; Set Y position
                        ret

    NoSlotAvailable:    
                        ret
SpawnGift ENDP


MAIN PROC
                        MOV  AX, @DATA
                        MOV  DS, AX

                        MOV  AH, 0                           ;following 3 lines to enter graphic mode
                        MOV  AL, 13h
                        INT  10h

                        ;call DrawLevel1
    ;call DrawLevel2
    call DrawLevel3

    gameLoop:           
                        CALL Collision
                        CALL DrawPadel
                        CALL MovePadel
                        mov  ball_color, 0
                        call DrawBall
                        call MoveBall
                        mov  ball_color, 2
                        call DrawBall
                        xor  bx, bx
                        mov  cx, gift_count
                        cmp  bx, cx
                        push bx


                        mov  gift_color, 0
                        mov  bow_color, 0
                        mov  ribbon_color, 0

                        CALL DrawGift
                        CALL MoveGift

                        mov  gift_color, 2
                        mov  bow_color, 4
                        mov  ribbon_color, 6

                        pop  bx

                        
                        CALL DrawGift

                        inc  bx
                        

                        JMP  gameLoop

                        MOV  AX, 4C00h
                        INT  21h
MAIN ENDP

beep proc
                        push ax
                        push bx
                        push cx
                        push dx
                        neg  ball_dy
                        mov  al, 182                         ; Prepare the speaker for the
                        out  43h, al                         ;  note.
                        mov  ax, 400                         ; Frequency number (in decimal)
    ;  for middle C.
                        out  42h, al                         ; Output low byte.
                        mov  al, ah                          ; Output high byte.
                        out  42h, al
                        in   al, 61h                         ; Turn on note (get value from
    ;  port 61h).
                        or   al, 00000011b                   ; Set bits 1 and 0.
                        out  61h, al                         ; Send new value.
                        mov  bx, 2                           ; Pause for duration of note.
.pause1:
                        mov  cx, 65535
.pause2:
                        dec  cx
                        jne  .pause2
                        dec  bx
                        jne  .pause1
                        in   al, 61h                         ; Turn off note (get value from
    ;  port 61h).
                        and  al, 11111100b                   ; Reset bits 1 and 0.
                        out  61h, al                         ; Send new value.

                        pop  dx
                        pop  cx
                        pop  bx
                        pop  ax

                        ret
beep endp

END MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
