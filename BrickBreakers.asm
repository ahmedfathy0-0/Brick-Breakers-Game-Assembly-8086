
.MODEL small
.STACK 100h

.DATA
    padel_x1      DW  135
    padel_x2      DW  185
    padel_y1      DW  187
    padel_y2      DW  190
    padel_color   db  4
    padel_speed   equ 7

    ball_x        DW  100
    ball_y        DW  100
    ball_dx       DW  1
    ball_dy       DW  1
    ball_size     equ 3
    ball_color    db  2
    diffeculty    db  0
    ;rectangles data
    
    colStart      dw  200
    rowStart      dw  20, 35, 50, 65
    rwidth        dw  40
    rheight       dw  10
    numRectangles dw  7


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
                     
                        mov  ax, ball_dy
                        neg  ax
                        mov  ball_dy, ax
    
                        jmp  continue_move

    ball_left_edge:     
                        mov  ball_dx, 1
                        jmp  continue_move

    ball_right_edge:    
                        mov  ball_dx, -1
                        jmp  continue_move

    continue_move:      
                        cmp  ball_y, 10
                        jle  ball_top_edge

                        cmp  ball_y, 190
                        jge  ball_bottom_edge

                        jmp  end_move

    ball_top_edge:      
                        mov  ball_dy, 1
                        jmp  end_move

    ball_bottom_edge:   
                        CALL ResetAll
    end_move:           
                        RET
MoveBall ENDP

ResetAll PROC
                        mov  ball_x, 100
                        mov  ball_y, 100
                        mov  ball_dx, 1
                        mov  ball_dy, 1
                        mov  padel_x1, 135
                        mov  padel_x2, 185
                        mov  padel_y1, 187
                        mov  padel_y2, 190
                        CALL ClearScreen
                        call DrawLevel1
                        CALL DrawPadel
                        mov ball_color, 2
                        CALL DrawBall
                        mov  ah, 0
                        int  16h
                        RET
ResetAll ENDP


DrawRectangle PROC
                        mov  dx,rowStart[di]          ;set row start of each rectangle
                        mov  ah,0ch                   ;command to draw pixel
    lp:                 
                        mov  cx,colStart              ;(row,col)
                        mov  bx,rwidth                ;set counter

    draw_t:             int  10h
                        inc  cx
                        dec  bx
                        cmp  bx, 0
                        jnz  draw_t
                        
                        mov  cx, colStart
    ; mov dx,1         ;(row,col)
    ; add dx,rowStart       ;(190,10)
                        inc  dx

                        mov  bx,rwidth                ;set counter
    draw_b:             int  10h
                        inc  cx
                        dec  bx
                        cmp  bx, 0
                        jnz  draw_b

                        mov  cx,colStart
                        inc  dx
                        
                        mov  cx, rowStart[di]
                        add  cx, rheight
                        cmp  dx, cx
                        jnz  lp
                        RET
DrawRectangle ENDP

DrawRow proc
                        mov  si, 0                    ; si is rectangle index
                        mov  al, 0
                        add  ax, di
    draw_loop:          
    ; Calculate the starting position for the current rectangle
                        push ax
                        mov  bx, si
                        mov  ax, 40                   ; Width of each rectangle
                        add  ax, 5                    ; Add a starting offset (5)
                        mul  bx                       ; ax * bx where width (40)
                        add  ax, 5                    ; Add a starting offset (10)  REMARK CAN BE DELETED
                        mov  colStart, ax             ; Store X position in colStart
                        pop  ax
                        inc  al                       ;change color of each rectangle
                        call DrawRectangle
                        
                        inc  si                       ; Move to the next rectangle
                        cmp  si,numRectangles
                        jnz  draw_loop
                        ret
DrawRow ENDP

DrawLevel1 proc
                        mov  di, 0                    ;index to rowStart array
    rows_loop:          
                        call DrawRow
                        add  di,2                     ;move 2 bytes to second element
                        cmp  di, 8
                        jnz  rows_loop
                        ret
DrawLevel1 endp


MAIN PROC
                        MOV  AX, @DATA
                        MOV  DS, AX

                        MOV  AH, 0                    ;following 3 lines to enter graphic mode
                        MOV  AL, 13h
                        INT  10h

                        call DrawLevel1

    gameLoop:           
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

END MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


