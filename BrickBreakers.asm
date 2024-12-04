
.MODEL small
.STACK 100h

.DATA
    padel_x1      DW  135
    padel_x2      DW  185
    padel_y1      DW  187
    padel_y2      DW  190
    padel_color   db  4
    padel_speed   equ 7

    ball_x        DW  160
    ball_y        DW  180
    ball_dx       DW  0
    ball_dy       DW  2
    ball_og_speed equ 2
    ball_size     equ 3
    divide_factor equ 10
    ball_color    db  2
    diffeculty    db  0
    
    ;Bricks number of rows and columns
    numRows       dw  8                                                                                     ; 2 * real number of rows
    rowStart      dw  20, 35, 50, 65
    numCols       dw  14                                                                                    ; 2 * real number of cols
    colStart      dw  5, 50, 95, 140, 185, 230, 275
    
    ;Bricks existence
    bricks        dw  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

    ;Brick dimensions
    rwidth        dw  40
    rheight       dw  10


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
                        inc  diffeculty
                        cmp  diffeculty, 01fh
                        jne  end_early
                        mov  diffeculty, 0
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
                        CALL DrawLevel1
                        CALL DrawPadel
                        mov  ball_color, 2
                        CALL DrawBall
                        mov  ah, 0
                        int  16h
                        RET
ResetAll ENDP

DrawRectangle PROC
                        mov  dx,rowStart[di]           ;set row start of each rectangle
                        mov  ah,0ch                    ;command to draw pixel
    lp:                 
                        mov  cx,colStart[si]           ;(row,col)

                        mov  bx,rwidth                 ;set counter
    draw_t:             int  10h
                        inc  cx
                        dec  bx
                        cmp  bx, 0
                        jnz  draw_t
                        
                        mov  cx, colStart[si]
                        inc  dx

                        mov  bx,rwidth                 ;set counter
    draw_b:             int  10h
                        inc  cx
                        dec  bx
                        cmp  bx, 0
                        jnz  draw_b

                        inc  dx
                        mov  cx, rowStart[di]
                        add  cx, rheight
                        cmp  dx, cx
                        jnz  lp
                        RET
DrawRectangle ENDP

DrawRow proc
                        mov  si, 0                     ; si is col-index
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
                        inc  al                        ;change color of each rectangle
                        cmp  dx, 1
                        jne  dont_draw
                        call DrawRectangle
    dont_draw:          
                        add  si, 2                     ; Move to the next rectangle
                        cmp  si, numCols
                        jnz  draw_loop
                        ret
DrawRow ENDP

DrawLevel1 proc
                        mov  di, 0                     ; di is row-index
    rows_loop:          
                        call DrawRow
                        add  di,2                      ;move 2 bytes to second element
                        cmp  di, numRows
                        jnz  rows_loop
                        ret
DrawLevel1 endp

Collision proc
                        push ax
                        push bx
                        push cx
                        push dx
                        push di
                        push si

                        mov  di, 0                     ; di is row-index
    collision_loop1:    
                        mov  si, 0                     ; si is col-index
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
                        add  si, 2                     ; Move to the next rectangle
                        cmp  si, numCols
                        jne  collision_loop2

                        add  di,2                      ;move 2 bytes to second element
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
    
                        pop  si
                        pop  di
                        pop  dx
                        pop  cx
                        pop  bx
                        pop  ax
                        ret
ClearBrick endp

MAIN PROC
                        MOV  AX, @DATA
                        MOV  DS, AX

                        MOV  AH, 0                     ;following 3 lines to enter graphic mode
                        MOV  AL, 13h
                        INT  10h

                        call DrawLevel1

    gameLoop:           
                        CALL Collision
                        CALL DrawPadel
                        CALL MovePadel

                        mov  ball_color, 0
                        call DrawBall

                        call MoveBall
                        mov  ball_color, 2
                        call DrawBall

                        JMP  gameLoop

                        MOV  AX, 4C00h
                        INT  21h
MAIN ENDP

beep proc
                        push ax
                        push bx
                        push cx
                        push dx
                        mov  al, 182                   ; Prepare the speaker for the
                        out  43h, al                   ;  note.
                        mov  ax, 400                   ; Frequency number (in decimal)
    ;  for middle C.
                        out  42h, al                   ; Output low byte.
                        mov  al, ah                    ; Output high byte.
                        out  42h, al
                        in   al, 61h                   ; Turn on note (get value from
    ;  port 61h).
                        or   al, 00000011b             ; Set bits 1 and 0.
                        out  61h, al                   ; Send new value.
                        mov  bx, 2                     ; Pause for duration of note.
.pause1:
                        mov  cx, 65535
.pause2:
                        dec  cx
                        jne  .pause2
                        dec  bx
                        jne  .pause1
                        in   al, 61h                   ; Turn off note (get value from
    ;  port 61h).
                        and  al, 11111100b             ; Reset bits 1 and 0.
                        out  61h, al                   ; Send new value.

                        pop  dx
                        pop  cx
                        pop  bx
                        pop  ax

                        ret
beep endp

END MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
