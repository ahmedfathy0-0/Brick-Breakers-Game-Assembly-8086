.MODEL small
.STACK 100h

.DATA
    padel_x1    DW  135
    padel_x2    DW  185
    padel_y1    DW  180
    padel_y2    DW  190
    padel_color equ 4
    padel_speed equ 10

    ball_x      DW  100
    ball_y      DW  100
    ball_dx     DW  1
    ball_dy     DW  1
    ball_color  equ 2

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

                     cmp  AL, 'd'
                     jz   MoveRight

                     cmp  AL, 'a'
                     jz   MoveLeft

    noKeyPressed:    
                     RET

    MoveRight:       
                     cmp  padel_x2, 310
                     jge  stop_move
                     add  padel_x1, padel_speed
                     add  padel_x2, padel_speed
                     RET
                     
    MoveLeft:        
                     cmp  padel_x1, 10
                     jle  stop_move
                     sub  padel_x1, padel_speed
                     sub  padel_x2, padel_speed
                     RET
    stop_move:       
                     RET

MovePadel ENDP





DrawBall PROC
                     mov  cx, ball_x
                     mov  dx, ball_y
                     mov  al, ball_color
                     mov  ah, 0ch
                     int  10h
                     RET
DrawBall ENDP

MoveBall PROC
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
                     mov  ball_dy, -1

    end_move:        
                     RET
MoveBall ENDP



GamePadel PROC
                     CALL DrawPadel
                     CALL DrawBall
                     CALL MoveBall
                     CALL MovePadel
GamePadel ENDP

Delay PROC
                     MOV  CX, 0003h
    delayLoop:       
                     LOOP delayLoop
                     RET
Delay ENDP

MAIN PROC
                     MOV  AX, @DATA
                     MOV  DS, AX

                     MOV  AH, 0
                     MOV  AL, 13h
                     INT  10h

    gameLoop:        

                     CALL ClearScreen
                     CALL GamePadel 
                     CALL Delay

                     JMP  gameLoop

                     MOV  AX, 4C00h
                     INT  21h
MAIN ENDP

END MAIN
