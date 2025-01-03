    EXTRN  ResetAll:FAR
    EXTRN  ResetAll_2:FAR
    EXTRN  Send:FAR
    EXTRN  Receive:FAR
    EXTRN  sendv:WORD
    EXTRN  recievev:WORD
    
    PUBLIC DrawPadel, DrawPadel_2, MovePadel, MovePadel_2
    PUBLIC DrawBall, DrawBall_2, MoveBall, MoveBall_2
    PUBLIC padel_x
    PUBLIC padel_x1
    PUBLIC padel_x2
    PUBLIC padel_y1 
    PUBLIC padel_color
    PUBLIC padel_y2   
    PUBLIC padel_speed
    PUBLIC padel_width

    PUBLIC padel_x_2     
    PUBLIC padel_x1_2    
    PUBLIC padel_x2_2    
    PUBLIC padel_y1_2    
    PUBLIC padel_y2_2    
    PUBLIC padel_color_2 
    PUBLIC padel_speed_2 
    PUBLIC padel_width_2
    PUBLIC char 
    
    PUBLIC ball_x               
    PUBLIC ball_y                
    PUBLIC ball_dx               
    PUBLIC ball_dy              
    PUBLIC ball_color            
    PUBLIC difficulty            
    PUBLIC original_difficulty  
    
    PUBLIC ball_x_2               
    PUBLIC ball_y_2                
    PUBLIC ball_dx_2               
    PUBLIC ball_dy_2              
    PUBLIC ball_color_2            
    PUBLIC difficulty_2            
    PUBLIC original_difficulty_2  

 

.MODEL small
.STACK 100h

.DATA
    padel_x               DW  200
    padel_x1              DW  0
    padel_x2              DW  0
    padel_y1              DW  581
    padel_y2              DW  590
    padel_color           db  4
    padel_speed           equ 8
    padel_width           dw  40
    char                  db  0
    
    ball_x                DW  199
    ball_y                DW  560
    ball_dx               DW  0
    ball_dy               DW  2
    ball_og_speed         equ 2
    ball_size             equ 3
    divide_factor         equ 2
    ball_color            db  2
    difficulty            db  0
    original_difficulty   db  0


    padel_x_2             DW  599
    padel_x1_2            DW  0
    padel_x2_2            DW  0
    padel_y1_2            DW  581
    padel_y2_2            DW  590
    padel_color_2         db  4
    padel_speed_2         equ 7
    padel_width_2         dw  40
    
    
    ball_x_2              DW  599
    ball_y_2              DW  560
    ball_dx_2             DW  0
    ball_dy_2             DW  2
    ball_og_speed_2       equ 2
    ball_size_2           equ 3
    divide_factor_2       equ 2
    ball_color_2          db  2
    difficulty_2          db  0
    original_difficulty_2 db  0

.CODE
DrawPadel PROC FAR
                          mov  dx, padel_y1
    fill_outer:           
                          inc  dx
                          cmp  dx, padel_y2
                          jz   end_Draw

                          mov  ax, padel_x
                          sub  ax, padel_width
                          mov  padel_x1, ax
                          mov  ax, padel_x
                          add  ax, padel_width
                          mov  padel_x2, ax

                          mov  cx, padel_x1
    fill_inner:           
                          inc  cx
                          cmp  cx, padel_x2
                          jz   fill_outer

                          mov  ah, 0ch
                          mov  al,[padel_color]
                          int  10h
                          jmp  fill_inner

    end_Draw:             
                          RET
DrawPadel ENDP


DrawPadel_2 PROC FAR
                          mov  dx, padel_y1_2
    fill_outer_2:         
                          inc  dx
                          cmp  dx, padel_y2_2
                          jz   end_Draw_2

                          mov  ax, padel_x_2
                          sub  ax, padel_width_2
                          mov  padel_x1_2, ax
                          mov  ax, padel_x_2
                          add  ax, padel_width_2
                          mov  padel_x2_2, ax

                          mov  cx, padel_x1_2
    fill_inner_2:         
                          inc  cx
                          cmp  cx, padel_x2_2
                          jz   fill_outer_2

                          mov  ah, 0ch
                          mov  al,[padel_color_2]
                          int  10h
                          jmp  fill_inner_2

    end_Draw_2:           
                          RET
DrawPadel_2 ENDP
MovePadel PROC FAR
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
                          ret

    MoveRight:            
    
                          cmp  padel_x2, 399
                          jge  stop_move

                          mov  [padel_color], 0
                          call DrawPadel
                          mov  [padel_color], 4

                          add  padel_x, padel_speed


                          mov  bx, padel_x
                          mov  cl,3
                          shr  bx, cl
                          or   bx,10000000b
                          mov  sendv, bx
                          call Send
                          ret

    MoveLeft:             
                          cmp  padel_x1, 10
                          jle  stop_move

                          mov  [padel_color], 0
                          call DrawPadel
                          mov  [padel_color], 4
                          sub  padel_x, padel_speed


                          mov  bx, padel_x
                          mov  cl,3
                          shr  bx, cl
                          or   bx,10000000b
                          mov  sendv, bx
                          call Send

                          ret

    stop_move:            
                          ret
MovePadel ENDP

MovePadel_2 PROC FAR
    ;mov recievev, 0
    ;call Receive
                          mov  bx, recievev
                          mov cl,3
                          shl  bx, cl
                          add  bx, 400

                          cmp  bx, padel_x_2
                          je   skipboi

                          cmp  recievev, 10
                          jb   skipboi

                          mov  [padel_color_2], 0
                          call DrawPadel_2
                          mov  [padel_color_2], 4
                          mov  padel_x_2, bx
                          call DrawPadel_2



    skipboi:              
                          mov  recievev, 0
                          ret
MovePadel_2 ENDP



DrawBall PROC FAR
		
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
DrawBall_2 PROC FAR
		
                          MOV  CX,ball_x_2
                          MOV  DX,ball_y_2
		
    DrawBall_HORIZONTAL_2:
                          MOV  AH,0Ch
                          MOV  AL,ball_color_2
                          MOV  BH,00h
                          INT  10h
			
                          INC  CX
                          MOV  AX,CX
                          SUB  AX,ball_x_2
                          CMP  AX,ball_size_2
                          JNG  DrawBall_HORIZONTAL_2
			
                          MOV  CX,ball_x_2
                          INC  DX
			
                          MOV  AX,DX
                          SUB  AX,ball_y_2
                          CMP  AX,ball_size_2
                          JNG  DrawBall_HORIZONTAL_2
		
                          RET
DrawBall_2 ENDP

    end_early:            
                          ret
MoveBall PROC FAR
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

                          cmp  ball_x, 0
                          jle  ball_left_edge

                          cmp  ball_x, 396
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
                          cmp  ball_y, 201
                          jle  ball_top_edge

                          cmp  ball_y, 597
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

    end_early_2:          
                          ret
MoveBall_2 PROC FAR

                          mov ball_color_2, 2
                          call DrawBall_2

                        ;   cmp  ball_y_2, 597
                        ;   jle  end_move_2
                          
                        ;   CALL ResetAll_2
    end_move_2:           
                          RET
MoveBall_2 ENDP


                          ret

END