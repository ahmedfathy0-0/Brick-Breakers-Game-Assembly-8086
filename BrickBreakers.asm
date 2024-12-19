
.MODEL small
.STACK 100h

.DATA
    padel_x1              DW  174
    padel_x2              DW  224
    padel_y1              DW  581
    padel_y2              DW  590
    padel_color           db  4
    padel_speed           equ 7
    padel_width           dw  70

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

    inReset               db  0

    ;Bricks number of rows and columns
    numRows               dw  8                                                                                                        ; 2 * real number of rows
    numRows1              equ 8
    numRows2              equ 14
    numRows3              equ 20
    rowStart              dw  205, 230, 255, 280, 305, 330, 355, 380, 405, 430

    numCols               dw  14                                                                                                       ; 2 * real number of cols
    numCols1              equ 14
    numCols2              equ 24
    numCols3              equ 44
    colStart1             dw  6, 62, 118, 174, 230, 286, 342
    colStart2             dw  3, 36, 69, 102, 135, 168, 201, 234, 267, 300, 333, 366
    colStart3             dw  3, 21, 39, 57, 75, 93, 111, 129, 147, 165, 183, 201, 219, 237, 255, 273, 291, 309, 327, 345, 363, 381

    dummycol              dw  ?
    dummyrow              dw  ?
    
    bricks                dw  220 DUP(1)                                                                                               ; max num of bricks in a level (lvl 3)                                                                                                                                                                                                                                                                                              ; 2 * numRows * numCols

    ;Brick dimensions
    rwidth                dw  50
    rheight               dw  20

    ;score & level
    score                 dw  0
    selected_level        db  0

    score1                equ 28                                                                                                       ; 4 * 7
    score2                equ 112                                                                                                      ; 4 * 7 + 7 * 12
    score3                equ 322                                                                                                      ; 4 * 7 + 7 * 12 + 10 * 21


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;Brick gifts
    gift_dy               dw  2
    gift_size             equ 6
    gift_speed            equ 10
    gift_color            db  ?
    ribbon_color          db  ?
    bow_color             db  ?
    gift_count            db  5
    backgournd_color      db  5 dup(0)
    gift_active           db  5 dup(0)
    gift_x                dw  5
    gift_y                dw  5
    gift_counter          dw  gift_speed
    gift_colors_list      db  2,5,9,14,15
    gift_ribbon_list      db  4,11,2,4,5
    gift_ball_color       db  2
    gift_timer            dw  0
    current_gift          dw  0
    is_there_gift         db  0
    
    current_gift_counter  db  0

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    padel_x1_2            DW  574
    padel_x2_2            DW  624
    padel_y1_2            DW  581
    padel_y2_2            DW  590
    padel_color_2         db  4
    padel_speed_2         equ 7
    padel_width_2         dw  70

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
        inReset_2               db  0


    ;Bricks number of rows and columns
    numRows_2             dw  8                                                                                                        ; 2 * real number of rows
    numRows1_2            equ 8
    numRows2_2            equ 14
    numRows3_2            equ 20
    rowStart_2            dw  205, 230, 255, 280, 305, 330, 355, 380, 405, 430

    numCols_2             dw  14                                                                                                       ; 2 * real number of cols
    numCols1_2            equ 14
    numCols2_2            equ 24
    numCols3_2            equ 44
    colStart1_2           dw  406, 462, 518, 574, 630, 686, 742
    colStart2_2           dw  403, 436, 469, 502, 535, 568, 601, 634, 667, 700, 733, 766
    colStart3_2           dw  403, 421, 439, 457, 475, 493, 511, 529, 547, 565, 583, 601, 619, 637, 655, 673, 691, 709, 727, 745, 763, 781

    dummycol_2            dw  ?
    dummyrow_2            dw  ?
    ;Bricks existence
    bricks_2              dw  220 DUP(1)                                                                                               ; max num of bricks in a level (lvl 3)                                                                                                                                                                                                                                                                                              ; 2 * numRows * numCols

    ;Brick dimensions
    rwidth_2              dw  50
    rheight_2             dw  20

    ;score & level
    score_2               dw  0
    selected_level_2      db  0

    score1_2              equ 28                                                                                                       ; 4 * 7
    score2_2              equ 112                                                                                                      ; 4 * 7 + 7 * 12
    score3_2              equ 322                                                                                                      ; 4 * 7 + 7 * 12 + 10 * 21


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;Brick gifts
    gift_dy_2             dw  2
    gift_size_2           equ 6
    gift_speed_2          equ 10
    gift_color_2          db  ?
    ribbon_color_2        db  ?
    bow_color_2           db  ?
    gift_count_2          db  5
    backgournd_color_2    db  5 dup(0)
    gift_active_2         db  5 dup(0)
    gift_x_2              dw  5
    gift_y_2              dw  5
    gift_counter_2        dw  gift_speed_2
    gift_colors_list_2    db  2,5,9,14,15
    gift_ribbon_list_2    db  4,11,2,4,5
    gift_ball_color_2     db  2
    gift_timer_2          dw  0
    current_gift_2        dw  0
    is_there_gift_2       db  0
    current_gift_counter_2  db  0



    char db 0
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
C6_freq    equ 3951
D6_freq    equ 3520
E6_freq    equ 3136
F6_freq    equ 2794
G6_freq    equ 2637
A6_freq    equ 2349
B6_freq    equ 2093
C7_freq    equ 1976
D7_freq    equ 1760
E7_freq    equ 1568
F7_freq    equ 1396
G7_freq    equ 1318
A7_freq    equ 1174
B7_freq    equ 1046
C8_freq    equ 987
D8_freq    equ 880
E8_freq    equ 784
F8_freq    equ 740
G8_freq    equ 698
A8_freq    equ 659

songNotes  dw F6_freq, E6_freq, D6_freq, C6_freq, D6_freq, E6_freq, G6_freq,
            D6_freq, E6_freq, F6_freq, G6_freq, A6_freq, B6_freq, C7_freq,
            B6_freq, A6_freq, G6_freq, F6_freq, E6_freq, D6_freq, C6_freq,
            E6_freq, G6_freq, A6_freq, F6_freq, E6_freq, D6_freq, G6_freq,
            A6_freq, G6_freq, B6_freq, C7_freq, E7_freq, D7_freq, G7_freq,
            F6_freq, F7_freq, E7_freq, F6_freq, D6_freq, C6_freq, G6_freq,
            A6_freq, D6_freq

noteCount  equ 40
noteTimer      dw 100       ; Timer to control note playing

freq       dw 0
currentNotePos dw 0     ; Tracks the current position in the songNotes array

timerForSwitch dw 60
ogTimerForSwitch equ 60



.CODE

    ; ClearScreen PROC
    ;                          mov       ax, 0A000h
    ;                          mov       es, ax
    ;                          xor       di, di
    ;                          mov       al, 0
    ;                          mov       cx, 480000
    ;                          rep       stosb
    ;                          RET
    ; ClearScreen ENDP
ClearScreen PROC
                           mov       al, 0
                           mov       dx, 570
    Clear_outer:            
                           inc       dx
                           cmp       dx, 600
                           jz        end_Clear

                           mov       cx, 0
    Clear_inner:            
                           inc       cx
                           cmp       cx, 400
                           jz        Clear_outer

                           mov       ah, 0ch
                           int       10h
                           jmp       Clear_inner

    end_Clear:              
                           RET
ClearScreen ENDP

ClearScreen_2 PROC
                           mov       al, 0
                           mov       dx, 550
    Clear_outer_2:            
                           inc       dx
                           cmp       dx, 600
                           jz        end_Clear_2

                           mov       cx, 400
    Clear_inner_2:            
                           inc       cx
                           cmp       cx, 800
                           jz        Clear_outer_2

                           mov       ah, 0ch
                           int       10h
                           jmp       Clear_inner_2

    end_Clear_2:              
                           RET
ClearScreen_2 ENDP



DrawPadel PROC

                           mov       dx, padel_y1
    fill_outer:            
                           inc       dx
                           cmp       dx, padel_y2
                           jz        end_Draw

                           mov       cx, padel_x1
    fill_inner:            
                           inc       cx
                           cmp       cx, padel_x2
                           jz        fill_outer

                           mov       ah, 0ch
                           int       10h
                           jmp       fill_inner

    end_Draw:              
                           RET
DrawPadel ENDP

DrawPadel_2 PROC
                           mov       cx, padel_x1_2
                           mov       dx, padel_y1_2
                           mov       al, padel_color_2
                           mov       ah, 0ch
    draw_top_2:            
                           int       10h
                           inc       cx
                           cmp       cx, padel_x2_2
                           jnz       draw_top_2

                           mov       cx, padel_x1_2
                           mov       dx, padel_y1_2
    draw_left_2:           
                           int       10h
                           inc       dx
                           cmp       dx, padel_y2_2
                           jnz       draw_left_2

                           mov       cx, padel_x2_2
                           mov       dx, padel_y1_2
    draw_right_2:          
                           int       10h
                           inc       dx
                           cmp       dx, padel_y2_2
                           jnz       draw_right_2

                           mov       cx, padel_x1_2
                           mov       dx, padel_y2_2
    draw_bottom_2:         
                           int       10h
                           inc       cx
                           cmp       cx, padel_x2_2
                           jnz       draw_bottom_2

                           mov       dx, padel_y1_2
    fill_outer_2:          
                           inc       dx
                           cmp       dx, padel_y2_2
                           jz        end_Draw_2

                           mov       cx, padel_x1_2
    fill_inner_2:          
                           inc       cx
                           cmp       cx, padel_x2_2
                           jz        fill_outer_2

                           mov       ah, 0ch
                           int       10h
                           jmp       fill_inner_2

    end_Draw_2:            
                           RET
DrawPadel_2 ENDP


    ; MovePadel PROC
    ;                          mov       ax, 3
    ;                          int       33h

    ;                          shr       cx, 1
    ;                          mov       si, cx
    ;                          sub       si, 25

    ;                          cmp       si, padel_x1
    ;                          je        no_move

    ;                          push      cx
    ;                          mov       padel_color, 0
    ;                          call      DrawPadel
    ;                          pop       cx
    ;                          mov       padel_x1, si

    ;                          add       si, padel_width
    ;                          mov       padel_x2, si


    ;                          mov       padel_color, 4
    ;                          call      DrawPadel

    ;     no_move:
    ;                          RET
    ; MovePadel ENDP
MovePadel PROC
                           mov       ah, 1
                           int       16h
                           jz        noKeyPressed
                           mov       ah, 0
                           int       16h
                           mov char,al

                           wait_for_uart:
                            in al, dx
                            and al, 00100000b                
                            jz noKeyPressed

                            mov dx, 3F8h               
                            mov al, char
                            out dx, al
                           cmp       AL, 'd'
                           jz        MoveRight
                           cmp       AL, 'a'
                           jz        MoveLeft
                          
    noKeyPressed:          
                           RET
    MoveRight:             
                           cmp       padel_x2, 399
                           jge       stop_move
                           mov       al, 0
                           call      DrawPadel
                           add       padel_x1, padel_speed
                           add       padel_x2, padel_speed
                           mov       padel_color, 4
                           RET
                     
    MoveLeft:              
                           cmp       padel_x1, 10
                           jle       stop_move
                                                      mov       al, 0


                           call      DrawPadel
                           sub       padel_x1, padel_speed
                           sub       padel_x2, padel_speed
                           mov       padel_color, 4
                           RET
    stop_move:             
                           RET
MovePadel ENDP


MovePadel_2 PROC
                            ; --- Check for UART Data Ready ---
                            mov dx, 3FDh               ; Line Status Register
                            in al, dx
                            and al, 1
                            jz noKeyPressed_2          ; If no UART data, check keyboard

                            ; --- Read UART Data ---
                            mov dx, 3F8h               ; Receive Data Register
                           in al, dx
                           cmp       AL, 'l'
                           jz        MoveRight_2
                           cmp       AL, 'j'
                           jz        MoveLeft_2
    noKeyPressed_2:        
                           RET
    MoveRight_2:           
                           cmp       padel_x2_2, 799
                           jge       stop_move_2
                           mov       padel_color_2, 0
                           call      DrawPadel_2
                           add       padel_x1_2, padel_speed_2
                           add       padel_x2_2, padel_speed_2
                           mov       padel_color_2, 4
                           RET
                     
    MoveLeft_2:            
                           cmp       padel_x1_2, 410
                           jle       stop_move_2
                           mov       padel_color_2, 0
                           call      DrawPadel_2
                           sub       padel_x1_2, padel_speed_2
                           sub       padel_x2_2, padel_speed_2
                           mov       padel_color_2, 4
                           RET
    stop_move_2:           
                           RET
MovePadel_2 ENDP

DrawBall PROC
		
                           MOV       CX,ball_x
                           MOV       DX,ball_y
		
    DrawBall_HORIZONTAL:   
                           MOV       AH,0Ch
                           MOV       AL,ball_color
                           MOV       BH,00h
                           INT       10h
			
                           INC       CX
                           MOV       AX,CX
                           SUB       AX,ball_x
                           CMP       AX,ball_size
                           JNG       DrawBall_HORIZONTAL
			
                           MOV       CX,ball_x
                           INC       DX
			
                           MOV       AX,DX
                           SUB       AX,ball_y
                           CMP       AX,ball_size
                           JNG       DrawBall_HORIZONTAL
		
                           RET
DrawBall ENDP
DrawBall_2 PROC
		
                           MOV       CX,ball_x_2
                           MOV       DX,ball_y_2
		
    DrawBall_HORIZONTAL_2: 
                           MOV       AH,0Ch
                           MOV       AL,ball_color_2
                           MOV       BH,00h
                           INT       10h
			
                           INC       CX
                           MOV       AX,CX
                           SUB       AX,ball_x_2
                           CMP       AX,ball_size_2
                           JNG       DrawBall_HORIZONTAL_2
			
                           MOV       CX,ball_x_2
                           INC       DX
			
                           MOV       AX,DX
                           SUB       AX,ball_y_2
                           CMP       AX,ball_size_2
                           JNG       DrawBall_HORIZONTAL_2
		
                           RET
DrawBall_2 ENDP

end_early:           
                           ret
MoveBall PROC
                           dec       difficulty
                           cmp       difficulty, 0
                           jne       end_early
                           mov       al, original_difficulty
                           mov       difficulty, al
                           mov       ax, ball_x
                           add       ax, ball_dx
                           mov       ball_x, ax

                           mov       ax, ball_y
                           add       ax, ball_dy
                           mov       ball_y, ax

                           cmp       ball_x, 0
                           jle       ball_left_edge

                           cmp       ball_x, 396
                           jge       ball_right_edge

                           mov       ax, ball_y
                           add       ax, ball_size
                           cmp       ax, padel_y1
                           jl        continue_move

                           mov       ax, ball_y
                           add       ax, ball_size
                           cmp       ax, padel_y2
                           jg        continue_move

                           mov       ax, ball_x
                           add       ax, ball_size
                           cmp       ax, padel_x1
                           jl        continue_move
                     
                           mov       ax, ball_x
                           add       ax, ball_size
                           cmp       ax, padel_x2
                           jg        continue_move
                           neg       ball_dy

                           mov       ax, padel_x1
                           add       ax, padel_x2
                           shr       ax, 1
                           cmp       ball_x, ax

                           jb        left_side

                           mov       bx, ball_x
                           sub       bx, ax
                           mov       cl ,3
                           shr       bx, cl
                           mov       ball_dx, bx
                           jmp       continue_move

    left_side:             

                           mov       bx, ball_x
                           sub       ax, bx
                           mov       cl, 3
                           shr       ax, cl
                           mov       ball_dx, ax
                           neg       ball_dx
                           jmp       continue_move

    ball_left_edge:        
                           neg       ball_dx
                           jmp       continue_move

    ball_right_edge:       
                           neg       ball_dx
                           jmp       continue_move

    continue_move:         
                           cmp       ball_y, 201
                           jle       ball_top_edge

                           cmp       ball_y, 597
                           jge       ball_bottom_edge

                           jmp       end_move

    ball_top_edge:         
                           neg       ball_dy
                           jmp       end_move

    ball_bottom_edge:      
                           CALL      ResetAll
    end_move:              
                           RET
MoveBall ENDP

end_early_2:           
                           ret
MoveBall_2 PROC
                           dec       difficulty_2
                           cmp       difficulty_2, 0
                           jne       end_early_2
                           mov       al, original_difficulty_2
                           mov       difficulty_2, al
                           mov       ax, ball_x_2
                           add       ax, ball_dx_2
                           mov       ball_x_2, ax

                           mov       ax, ball_y_2
                           add       ax, ball_dy_2
                           mov       ball_y_2, ax

                           cmp       ball_x_2, 401
                           jle       ball_left_edge_2

                           cmp       ball_x_2, 796
                           jge       ball_right_edge_2

                           mov       ax, ball_y_2
                           add       ax, ball_size_2
                           cmp       ax, padel_y1_2
                           jl        continue_move_2

                           mov       ax, ball_y_2
                           add       ax, ball_size_2
                           cmp       ax, padel_y2_2
                           jg        continue_move_2

                           mov       ax, ball_x_2
                           add       ax, ball_size_2
                           cmp       ax, padel_x1_2
                           jl        continue_move_2
                     
                           mov       ax, ball_x_2
                           add       ax, ball_size_2
                           cmp       ax, padel_x2_2
                           jg        continue_move_2
                           neg       ball_dy_2

                           mov       ax, padel_x1_2
                           add       ax, padel_x2_2
                           shr       ax, 1
                           cmp       ball_x_2, ax

                           jb        left_side_2

                           mov       bx, ball_x_2
                           sub       bx, ax
                           mov       cl ,3
                           shr       bx, cl
                           mov       ball_dx_2, bx
                           jmp       continue_move_2

    left_side_2:           

                           mov       bx, ball_x_2
                           sub       ax, bx
                           mov       cl, 3
                           shr       ax, cl
                           mov       ball_dx_2, ax
                           neg       ball_dx_2
                           jmp       continue_move_2

    ball_left_edge_2:      
                           neg       ball_dx_2
                           jmp       continue_move_2

    ball_right_edge_2:     
                           neg       ball_dx_2
                           jmp       continue_move_2

    continue_move_2:       
                           cmp       ball_y_2, 201
                           jle       ball_top_edge_2

                           cmp       ball_y_2, 597
                           jge       ball_bottom_edge_2

                           jmp       end_move_2

    ball_top_edge_2:       
                           neg       ball_dy_2
                           jmp       end_move_2

    ball_bottom_edge_2:    
                           CALL      ResetAll_2
    end_move_2:            
                           RET
MoveBall_2 ENDP
ResetAll PROC
                           mov       ball_x, 199
                           mov       ball_y, 560
                           mov       ball_dx, ball_og_speed
                           mov       ball_dy, ball_og_speed
                           mov       padel_x1, 174
                           mov       padel_x2, 224
                           mov       padel_y1, 581
                           mov       padel_y2, 590
                           mov       ball_dy, 2
                           mov       ball_dx, 0
                           mov       [gift_ball_color],2
                           mov       [gift_timer],0

                           mov gift_color, 0
                            mov bow_color, 0
                            mov ribbon_color, 0
                            CALL DrawGift
                           CALL      ClearScreen
                           cmp       selected_level, 1
                           jnz       cont1
                           CALL      DrawLevel1
                           jmp       cont
    cont1:                 
                           cmp       selected_level, 2
                           jnz       cont2
                           CALL      DrawLevel2
                           jmp       cont
    cont2:                 
                           cmp       selected_level, 3
                           CALL      DrawLevel3
    cont:                  
                           CALL      DrawPadel
                           mov       ball_color, 2
                           CALL      DrawBall
                           mov       bx,0
    ResetAllGifts:         
                           mov       byte ptr [gift_active+bx], 0
                           mov       gift_x, 0
                           mov       gift_y, 0
                           inc       bl
                           cmp       bl,[gift_count]
                           jne       ResetAllGifts
                           CALL      DrawPadel
                           
                           mov inReset, 1

                           RET
ResetAll ENDP
ResetAll_2 PROC
                           mov       ball_x_2, 599
                           mov       ball_y_2, 560
                           mov       ball_dx_2, ball_og_speed_2
                           mov       ball_dy_2, ball_og_speed_2
                           mov       padel_x1_2, 574
                           mov       padel_x2_2, 624
                           mov       padel_y1_2, 581
                           mov       padel_y2_2, 590
                           mov       ball_dy_2, 2
                           mov       ball_dx_2, 0
                           mov       [gift_ball_color_2],2
                           mov       [gift_timer_2],0

                           mov gift_color_2, 0
                            mov bow_color_2, 0
                            mov ribbon_color_2, 0
                            CALL DrawGift_2
                           CALL      ClearScreen_2
                           cmp       selected_level_2, 1
                           jnz       cont1_2
                           CALL      DrawLevel1_2
                           jmp       cont_2
    cont1_2:                 
                           cmp       selected_level_2, 2
                           jnz       cont2_2
                           CALL      DrawLevel2_2
                           jmp       cont_2
    cont2_2:                 
                           cmp       selected_level_2, 3
                           CALL      DrawLevel3_2
    cont_2:                  
                           CALL      DrawPadel_2
                           mov       ball_color_2, 2
                           CALL      DrawBall_2
                           mov       bx,0
    ResetAllGifts_2:         
                           mov       byte ptr [gift_active_2+bx], 0
                           mov       gift_x_2, 0
                           mov       gift_y_2, 0
                           inc       bl
                           cmp       bl,[gift_count_2]
                           jne       ResetAllGifts_2
                           CALL      DrawPadel_2
                           mov inReset_2, 1
                           RET
ResetAll_2 ENDP

ResetBricks proc
                           mov       di, 0
    rows_reset_loop:       
                           mov       si, 0
                           mov       ax, di
                           mov       bx, numCols
                           mul       bx
                           mov       bx, ax
    cols_reset_loop:       
                           mov       bricks[bx], 1

                           add       bx, 2
                           add       si, 2
                           cmp       si, 48
                           jne       cols_reset_loop

                           add       di, 2
                           cmp       di, 22
                           jne       rows_reset_loop
                           ret
ResetBricks endp
ResetBricks_2 proc
                           mov       di, 0
    rows_reset_loop_2:     
                           mov       si, 0
                           mov       ax, di
                           mov       bx, numCols_2
                           mul       bx
                           mov       bx, ax
    cols_reset_loop_2:     
                           mov       bricks_2[bx], 1

                           add       bx, 2
                           add       si, 2
                           cmp       si, 48
                           jne       cols_reset_loop_2

                           add       di, 2
                           cmp       di, 22
                           jne       rows_reset_loop_2
                           ret
ResetBricks_2 endp

MoveGift PROC
                           push      bx
                           mov       cl, gift_count
                           mov       ch,0
                           xor       bx, bx

                        

    LoopMoveGifts:         
                           cmp       bx, cx
                           jge       EndMove


    ; Check if gift is active
                           cmp       [gift_active + bx], 0               ; Is the gift active?
                           je        SkipGift
                           
    ; Decrement counter
                           dec       [gift_counter]                    ; Decrement gift's counter
                           jnz       SkipGift

    ; Reset counter
                           mov       ax, gift_speed
                           mov       [gift_counter], ax

    ; Move gift down
                           mov       ax, gift_y
                           add       ax, gift_dy
                           mov       [gift_y], ax                      ; Update Y positionFre
                           
    continue_move_gift:    
                           cmp       ax, 590
                           jl        check_gift_collision
                           mov       byte ptr [gift_active+bx], 0
                           mov       [is_there_gift],0
                           jmp       SkipGift
                        
    check_gift_collision:  
                           mov       ax, gift_y
                           add       ax, gift_size
                           cmp       ax, padel_y1
                           jl        SkipGift

                           mov       ax, gift_y
                           add       ax, ball_size
                           cmp       ax, padel_y2
                           jg        SkipGift

                           mov       ax, gift_x
                           add       ax, gift_size
                           cmp       ax, padel_x1
                           jl        SkipGift
                     
                           mov       ax, gift_x
                           add       ax, gift_size
                           cmp       ax, padel_x2
                           jg        SkipGift
                        
                           cmp       [gift_colors_list+bx],2           ; Check if gift_color is 2
                           je        SetColor4                         ; Jump to set gift_ball_color to 4

                           cmp       [gift_colors_list+bx], 5          ; Check if gift_color is 5
                           je        SetColor14                        ; Jump to set gift_ball_color to 14

                           cmp       [gift_colors_list+bx], 9          ; Check if gift_color is 9
                           je        SetColor5                         ; Jump to set gift_ball_color to 5

                           cmp       [gift_colors_list+bx], 14         ; Check if gift_color is 14
                           je        SetColor1                         ; Jump to set gift_ball_color to 1

                           cmp       [gift_colors_list+bx], 15         ; Check if gift_color is 15
                           je        SetColor13                        ; Jump to set gift_ball_color to 13

                           jmp       EndSetColor                       ; Skip to end if no condition matches

    SetColor4:             
                           mov       [gift_ball_color], 4
                           jmp       EndSetColor                       ; Jump to end

    SetColor14:            
                           mov       [gift_ball_color], 14
                           mov       [padel_width],90
                           jmp       EndSetColor                       ; Jump to end

    SetColor5:             
                           mov       [gift_ball_color], 5
                           mov       [padel_width],30
                           jmp       EndSetColor                       ; Jump to end

    SetColor1:             
                           mov       [gift_ball_color], 1
                           mov       padel_x1,155
                           mov       padel_x2, 165
                           jmp       EndSetColor                       ; Jump to end

    SetColor13:            
                           mov       [gift_ball_color], 13

    EndSetColor:           
                           mov       gift_timer, 0                     ; Reset gift_timer


    SkipGift:              
                           inc       bx
                           jmp       LoopMoveGifts

    EndMove:               
                           pop       bx
                           ret
MoveGift ENDP

MoveGift_2 PROC
                           push      bx
                           mov       cl, gift_count_2
                           mov       ch,0
                           xor       bx, bx
                        

    LoopMoveGifts_2:       
                           cmp       bx, cx
                           jge       EndMove_2


    ; Check if gift is active
                           cmp       [gift_active_2+bx], 0             ; Is the gift active?
                           je        SkipGift_2

    ; Decrement counter
                           dec       [gift_counter_2]                  ; Decrement gift's counter
                           jnz       SkipGift_2
                        
                           push      cx
                           push      ax
                           mov       gift_color_2, 0
                           mov       bow_color_2, 0
                           mov       ribbon_color_2, 0

                           CALL      DrawGift_2
                           pop       ax
                           pop       cx

    ; Reset counter
                           mov       ax, gift_speed_2
                           mov       [gift_counter_2], ax

    ; Move gift down
                           mov       ax, gift_y_2
                           add       ax, gift_dy_2
                           mov       [gift_y_2], ax                    ; Update Y positionFre

    continue_move_gift_2:  
                           cmp       ax, 590
                           jl        check_gift_collision_2
                           mov       byte ptr [gift_active_2+bx], 0
                           mov       [is_there_gift_2],0
                           jmp       SkipGift_2
                        
    check_gift_collision_2:
                           mov       ax, gift_y_2
                           add       ax, gift_size_2
                           cmp       ax, padel_y1_2
                           jl        SkipGift_2

                           mov       ax, gift_y_2
                           add       ax, ball_size_2
                           cmp       ax, padel_y2_2
                           jg        SkipGift_2

                           mov       ax, gift_x_2
                           add       ax, gift_size_2
                           cmp       ax, padel_x1_2
                           jl        SkipGift_2
                     
                           mov       ax, gift_x_2
                           add       ax, gift_size_2
                           cmp       ax, padel_x2_2
                           jg        SkipGift_2
                        
                           cmp       [gift_colors_list_2+bx],2         ; Check if gift_color is 2
                           je        SetColor4_2                       ; Jump to set gift_ball_color to 4

                           cmp       [gift_colors_list_2+bx], 5        ; Check if gift_color is 5
                           je        SetColor14_2                      ; Jump to set gift_ball_color to 14

                           cmp       [gift_colors_list_2+bx], 9        ; Check if gift_color is 9
                           je        SetColor5_2                       ; Jump to set gift_ball_color to 5

                           cmp       [gift_colors_list_2+bx], 14       ; Check if gift_color is 14
                           je        SetColor1_2                       ; Jump to set gift_ball_color to 1

                           cmp       [gift_colors_list_2+bx], 15       ; Check if gift_color is 15
                           je        SetColor13_2                      ; Jump to set gift_ball_color to 13

                           jmp       EndSetColor_2                     ; Skip to end if no condition matches

    SetColor4_2:           
                           mov       [gift_ball_color_2], 4
                           jmp       EndSetColor_2                     ; Jump to end

    SetColor14_2:          
                           mov       [gift_ball_color_2], 14
                           mov       [padel_width_2],90
                           jmp       EndSetColor_2                     ; Jump to end

    SetColor5_2:           
                           mov       [gift_ball_color], 5
                           mov       [padel_width_2],30
                           jmp       EndSetColor_2                     ; Jump to end

    SetColor1_2:           
                           mov       [gift_ball_color_2], 1
                           mov       padel_x1_2,155
                           mov       padel_x2_2, 165
                           jmp       EndSetColor_2                     ; Jump to end

    SetColor13_2:          
                           mov       [gift_ball_color_2], 13

    EndSetColor_2:         
                           mov       gift_timer_2, 0                   ; Reset gift_timer


    SkipGift_2:            
                           inc       bx
                           jmp       LoopMoveGifts_2

    EndMove_2:             
                           pop       bx
                           ret
MoveGift_2 ENDP

DrawGift PROC
                           push      bx                                ; Check if the gift is active
                           mov       bl, [current_gift_counter]
                           mov       bh,0
                           cmp       [gift_active + bx], 0
                           je        SkipDrawing                       ; Skip if not active


    ; Use calculated offsets to access gift_x_list and gift_y_list
                           mov       cx, gift_x                        ; Get X position of the gift
                           mov       dx, gift_y                        ; Get Y position of the gift
                           push      cx
                           push      dx
                           mov       bx, gift_size                     ; Load the gift size
                           mov       si, 0
    DrawColumnG:           
                           push      cx
                           mov       di, 0
    DrawRowG:              
                           mov       ah, 0Ch
                           mov       al, gift_color
                           int       10h

                           inc       cx
                           inc       di
                           cmp       di, bx
                           jl        DrawRowG
                           pop       cx
                           inc       dx
                           inc       si
                           cmp       si, bx
                           jl        DrawColumnG
                           pop       dx
                           pop       cx
                           push      cx
                           push      dx

    ; Draw horizontal ribbon
                           mov       si, gift_size
                           shr       si, 1
                           add       dx, si
                           mov       di, 0
    RibbonHorizontal:      
                           mov       ah, 0Ch
                           mov       al, ribbon_color
                           int       10h

                           inc       cx
                           inc       di
                           cmp       di, bx
                           jl        RibbonHorizontal

    ; Draw vertical ribbon
                           pop       dx
                           pop       cx
                           push      cx
                           push      dx
                           add       cx, si
                           mov       di, 0
    RibbonVertical:        
    ; Set pixel for ribbon (Vertical)

                           mov       ah, 0Ch
                           mov       al, ribbon_color
                           int       10h

                           inc       dx
                           inc       di
                           cmp       di, bx
                           jl        RibbonVertical

    ; Draw bow (top decoration)
                           pop       dx
                           pop       cx
                           mov       di, 0
    DrawBow:               
                           mov       ah, 0Ch
                           mov       al, bow_color
                           int       10h

                           inc       cx
                           inc       di
                           cmp       di, gift_size
                           jl        DrawBow
    SkipDrawing:           
                           pop       bx
                           RET
DrawGift ENDP

DrawGift_2 PROC
                           mov bl, [current_gift_counter_2]
                            mov bh,0
                           cmp       [gift_active_2+bx], 0
                           push      bx                                ; Check if the gift is active
                           je        SkipDrawing_2                     ; Skip if not active


    ; Use calculated offsets to access gift_x_list and gift_y_list
                           mov       cx, gift_x_2                      ; Get X position of the gift
                           mov       dx, gift_y_2                      ; Get Y position of the gift
                           mov       bx, gift_size_2                   ; Load the gift size
                           push      cx
                           push      dx
                           mov       si, 0
    DrawColumnG_2:         
                           push      cx
                           mov       di, 0
    DrawRowG_2:            
                           mov       ah, 0Ch
                           mov       al, gift_color_2
                           int       10h

                           inc       cx
                           inc       di
                           cmp       di, bx
                           jl        DrawRowG_2
                           pop       cx
                           inc       dx
                           inc       si
                           cmp       si, bx
                           jl        DrawColumnG_2
                           pop       dx
                           pop       cx
                           push      cx
                           push      dx

    ; Draw horizontal ribbon
                           mov       si, gift_size_2
                           shr       si, 1
                           add       dx, si
                           mov       di, 0
    RibbonHorizontal_2:    
                           mov       ah, 0Ch
                           mov       al, ribbon_color_2
                           int       10h

                           inc       cx
                           inc       di
                           cmp       di, bx
                           jl        RibbonHorizontal_2

    ; Draw vertical ribbon
                           pop       dx
                           pop       cx
                           push      cx
                           push      dx
                           add       cx, si
                           mov       di, 0
    RibbonVertical_2:      
    ; Set pixel for ribbon (Vertical)

                           mov       ah, 0Ch
                           mov       al, ribbon_color_2
                           int       10h

                           inc       dx
                           inc       di
                           cmp       di, bx
                           jl        RibbonVertical_2

    ; Draw bow (top decoration)
                           pop       dx
                           pop       cx
                           mov       di, 0
    DrawBow_2:             
                           mov       ah, 0Ch
                           mov       al, bow_color_2
                           int       10h

                           inc       cx
                           inc       di
                           cmp       di, gift_size_2
                           jl        DrawBow_2
    SkipDrawing_2:         
                           pop       bx
                           RET
DrawGift_2 ENDP



DrawRectangle1 PROC
    ;to calculate final column
                           mov       dx,rowStart[di]                   ;set row start of each rectangle
                           mov       ah,0ch                            ;command to draw pixel

                           mov       bx, rheight                       ; bx = height
                           add       bx, dx                            ; bx = height + row = final row to draw in
                           mov       dummyrow, bx                      ;dummyrow now holds the final row

    ;to calculate final column
                           mov       bx, rwidth                        ;bx = rectangle wdith
                           add       bx, colStart1[si]                 ;bx += column start
                           mov       dummycol, bx                      ;dummycol now has the final column to draw
        
    height_loop:                                                       ;draws pixels along the height (rows)
                           mov       cx,colStart1[si]

    width_loop:            int       10h                               ;draws pixels along the width (columns) for one row
                           inc       cx
                           cmp       cx, dummycol
                           jnz       width_loop


                           inc       dx
                           cmp       dx, dummyrow
                           jnz       height_loop
                           ret
DrawRectangle1 ENDP
DrawRectangle1_2 PROC
    ;to calculate final column
                           mov       dx,rowStart_2[di]                 ;set row start of each rectangle
                           mov       ah,0ch                            ;command to draw pixel

                           mov       bx, rheight_2                     ; bx = height
                           add       bx, dx                            ; bx = height + row = final row to draw in
                           mov       dummyrow_2, bx                    ;dummyrow now holds the final row

    ;to calculate final column
                           mov       bx, rwidth_2                      ;bx = rectangle wdith
                           add       bx, colStart1_2[si]               ;bx += column start
                           mov       dummycol_2, bx                    ;dummycol now has the final column to draw
        
    height_loop_2:                                                     ;draws pixels along the height (rows)
                           mov       cx,colStart1_2[si]

    width_loop_2:          int       10h                               ;draws pixels along the width (columns) for one row
                           inc       cx
                           cmp       cx, dummycol_2
                           jnz       width_loop_2


                           inc       dx
                           cmp       dx, dummyrow_2
                           jnz       height_loop_2
                           ret
DrawRectangle1_2 ENDP

DrawRectangle2 PROC
    ;to calculate final column
                           mov       dx,rowStart[di]                   ;set row start of each rectangle
                           mov       ah,0ch                            ;command to draw pixel

                           mov       bx, rheight                       ; bx = height
                           add       bx, dx                            ; bx = height + row = final row to draw in
                           mov       dummyrow, bx                      ;dummyrow now holds the final row

    ;to calculate final column
                           mov       bx, rwidth                        ;bx = rectangle wdith
                           add       bx, colStart2[si]                 ;bx += column start
                           mov       dummycol, bx                      ;dummycol now has the final column to draw
        
    height2_loop:                                                      ;draws pixels along the height (rows)
                           mov       cx,colStart2[si]

    width2_loop:           int       10h                               ;draws pixels along the width (columns) for one row
                           inc       cx
                           cmp       cx, dummycol
                           jnz       width2_loop


                           inc       dx
                           cmp       dx, dummyrow
                           jnz       height2_loop
                           ret
DrawRectangle2 ENDP
DrawRectangle2_2 PROC
    ;to calculate final column
                           mov       dx,rowStart_2[di]                 ;set row start of each rectangle
                           mov       ah,0ch                            ;command to draw pixel

                           mov       bx, rheight_2                     ; bx = height
                           add       bx, dx                            ; bx = height + row = final row to draw in
                           mov       dummyrow_2, bx                    ;dummyrow now holds the final row

    ;to calculate final column
                           mov       bx, rwidth_2                      ;bx = rectangle wdith
                           add       bx, colStart2_2[si]               ;bx += column start
                           mov       dummycol_2, bx                    ;dummycol now has the final column to draw
        
    height2_loop_2:                                                    ;draws pixels along the height (rows)
                           mov       cx,colStart2_2[si]

    width2_loop_2:         int       10h                               ;draws pixels along the width (columns) for one row
                           inc       cx
                           cmp       cx, dummycol_2
                           jnz       width2_loop_2


                           inc       dx
                           cmp       dx, dummyrow_2
                           jnz       height2_loop_2
                           ret
DrawRectangle2_2 ENDP

DrawRectangle3 PROC
    ;to calculate final column
                           mov       dx,rowStart[di]                   ;set row start of each rectangle
                           mov       ah,0ch                            ;command to draw pixel

                           mov       bx, rheight                       ; bx = height
                           add       bx, dx                            ; bx = height + row = final row to draw in
                           mov       dummyrow, bx                      ;dummyrow now holds the final row

    ;to calculate final column
                           mov       bx, rwidth                        ;bx = rectangle wdith
                           add       bx, colStart3[si]                 ;bx += column start
                           mov       dummycol, bx                      ;dummycol now has the final column to draw
        
    height3_loop:                                                      ;draws pixels along the height (rows)
                           mov       cx,colStart3[si]

    width3_loop:           int       10h                               ;draws pixels along the width (columns) for one row
                           inc       cx
                           cmp       cx, dummycol
                           jnz       width3_loop


                           inc       dx
                           cmp       dx, dummyrow
                           jnz       height3_loop
                           ret
DrawRectangle3 ENDP
DrawRectangle3_2 PROC
    ;to calculate final column
                           mov       dx,rowStart_2[di]                 ;set row start of each rectangle
                           mov       ah,0ch                            ;command to draw pixel

                           mov       bx, rheight_2                     ; bx = height
                           add       bx, dx                            ; bx = height + row = final row to draw in
                           mov       dummyrow_2, bx                    ;dummyrow now holds the final row

    ;to calculate final column
                           mov       bx, rwidth_2                      ;bx = rectangle wdith
                           add       bx, colStart3_2[si]               ;bx += column start
                           mov       dummycol_2, bx                    ;dummycol now has the final column to draw
        
    height3_loop_2:                                                    ;draws pixels along the height (rows)
                           mov       cx,colStart3_2[si]

    width3_loop_2:         int       10h                               ;draws pixels along the width (columns) for one row
                           inc       cx
                           cmp       cx, dummycol_2
                           jnz       width3_loop_2


                           inc       dx
                           cmp       dx, dummyrow_2
                           jnz       height3_loop_2
                           ret
DrawRectangle3_2 ENDP

DrawRow proc
                           mov       si, 0                             ; si is col-index
                           mov       al, 0

    draw_loop:             
                           push      ax
                           mov       ax, di
                           mov       cx, numCols
                           mul       cx
                           mov       cx, 2
                           div       cx
                           mov       bx, ax
                           add       bx, si

                           mov       dx, bricks[bx]
                           pop       ax
                           inc       al                                ;change color of each rectangle
                           cmp       dx, 1
                           jne       dont_draw

                           cmp       selected_level, 1
                           je        level1
                           cmp       selected_level, 2
                           je        level2
                           cmp       selected_level, 3
                           je        level3

    level1:                
                           call      DrawRectangle1
                           jmp       dont_draw

    level2:                
                           call      DrawRectangle2
                           jmp       dont_draw
    level3:                
                           call      DrawRectangle3
                           jmp       dont_draw

    dont_draw:             
                           add       si, 2                             ; Move to the next rectangle
                           cmp       si, numCols
                           jnz       draw_loop
                           ret
DrawRow ENDP

DrawRow_2 proc
                           mov       si, 0                             ; si is col-index
                           mov       al, 0

    draw_loop_2:           
                           push      ax
                           mov       ax, di
                           mov       cx, numCols_2
                           mul       cx
                           mov       cx, 2
                           div       cx
                           mov       bx, ax
                           add       bx, si

                           mov       dx, bricks_2[bx]
                           pop       ax
                           inc       al                                ;change color of each rectangle
                           cmp       dx, 1
                           jne       dont_draw_2

                           cmp       selected_level_2, 1
                           je        level1_2
                           cmp       selected_level_2, 2
                           je        level2_2
                           cmp       selected_level_2, 3
                           je        level3_2

    level1_2:              
                           call      DrawRectangle1_2
                           jmp       dont_draw_2

    level2_2:              
                           call      DrawRectangle2_2
                           jmp       dont_draw_2
    level3_2:              
                           call      DrawRectangle3_2
                           jmp       dont_draw_2

    dont_draw_2:           
                           add       si, 2                             ; Move to the next rectangle
                           cmp       si, numCols_2
                           jnz       draw_loop_2
                           ret
DrawRow_2 ENDP

DrawLevel1 proc
                           mov       di, 0                             ; di is row-index
                           mov       numRows, numRows1
                           mov       numCols, numCols1
                           mov       difficulty, 01fh
                           mov       original_difficulty, 04h
                           mov       selected_level, 1
    rows_loop:             
                           call      DrawRow
                           add       di,2                              ;move 2 bytes to second element
                           cmp       di, numRows
                           jnz       rows_loop
                           ret
DrawLevel1 endp

DrawLevel1_2 proc
                           mov       di, 0                             ; di is row-index
                           mov       numRows_2, numRows1_2
                           mov       numCols_2, numCols1_2
                           mov       difficulty_2, 01fh
                           mov       original_difficulty_2, 04h
                           mov       selected_level_2, 1
    rows_loop_2:             
                           call      DrawRow_2
                           add       di,2                              ;move 2 bytes to second element
                           cmp       di, numRows_2
                           jnz       rows_loop_2
                           ret
DrawLevel1_2 endp

DrawLevel2 proc
                           mov       di, 0                             ; di is row-index
                           mov       numRows, numRows2
                           mov       numCols, numCols2
                           mov       rwidth, 20
                           mov       difficulty, 0dh
                           mov       original_difficulty, 03h
                           mov       selected_level, 2


    lvl2:                  
                           call      DrawRow
                           add       di,2                              ;move 2 bytes to second element
                           cmp       di, numRows
                           jnz       lvl2
                           ret

DrawLevel2 endp

DrawLevel2_2 proc
                           mov       di, 0                             ; di is row-index
                           mov       numRows_2, numRows2_2
                           mov       numCols_2, numCols2_2
                           mov       rwidth_2, 20
                           mov       difficulty_2, 0dh
                           mov       original_difficulty_2, 03h
                           mov       selected_level_2, 2


    lvl2_2:                  
                           call      DrawRow_2
                           add       di,2                              ;move 2 bytes to second element
                           cmp       di, numRows_2
                           jnz       lvl2_2
                           ret

DrawLevel2_2 endp

DrawLevel3 proc
                           mov       di, 0                             ; di is row-index
                           mov       numRows, numRows3
                           mov       numCols, numCols3
                           mov       rwidth, 10
                           mov       difficulty, 09h
                           mov       original_difficulty, 01h
                           mov       selected_level, 3

    lvl3:                  
                           call      DrawRow
                           add       di,2                              ;move 2 bytes to second element
                           cmp       di, numRows
                           jnz       lvl3
                           ret
DrawLevel3 endp

DrawLevel3_2 proc
                           mov       di, 0                             ; di is row-index
                           mov       numRows_2, numRows3_2
                           mov       numCols_2, numCols3_2
                           mov       rwidth_2, 10
                           mov       difficulty_2, 09h
                           mov       original_difficulty_2, 01h
                           mov       selected_level_2, 3

    lvl3_2:                
                           call      DrawRow_2
                           add       di,2                              ;move 2 bytes to second element
                           cmp       di, numRows_2
                           jnz       lvl3_2
                           ret
DrawLevel3_2 endp

Collision macro lvl
LOCAL coll1
LOCAL coll2
LOCAL coll3
LOCAL coll_end
                cmp       lvl, 1
                je        coll1
                cmp       lvl, 2
                je        coll2
                cmp       lvl, 3
                je        coll3
    coll1:      
                call      Collision1
                jmp       coll_end
    coll2:             
                       call      Collision2
                jmp       coll_end
    coll3:             
                       call      Collision3
    coll_end:              
endm

Collision_2 macro lvl_2
LOCAL coll1_2
LOCAL coll2_2
LOCAL coll3_2
LOCAL coll_end_2
                  cmp       lvl_2, 1
                  je        coll1_2
                  cmp       lvl_2, 2
                  je        coll2_2
                  cmp       lvl_2, 3
                  je        coll3_2
    coll1_2:    
                  call      Collision1_2
                  jmp       coll_end_2
    coll2_2:           
                         call      Collision2_2
                  jmp       coll_end_2
    coll3_2:           
                         call      Collision3_2
    coll_end_2:                
endm

Collision1 proc
                           push      ax
                           push      bx
                           push      cx
                           push      dx
                           push      di
                           push      si

                           mov       di, 0                             ; di is row-index
    collision1_loop1:      
                           mov       si, 0                             ; si is col-index

                           mov       ax, rowStart[di]
                           sub       ax, ball_size
                           cmp       ax, ball_y
                           jg        not_in_row1

                           add       ax, rheight
                           add       ax, ball_size
                           cmp       ax, ball_y
                           jl        not_in_row1
    collision1_loop2:      

                           mov       ax, colStart1[si]
                           sub       ax, ball_size
                           cmp       ax, ball_x
                           jg        not_in_col1

                           add       ax, rwidth
                           add       ax, ball_size
                           cmp       ax, ball_x
                           jl        not_in_col1

                           mov       ax, di
                           mov       cx, numCols
                           mul       cx
                           mov       cx,2
                           div       cx
                           mov       bx, ax
                           add       bx, si
                           mov       ax, bricks[bx]
                           cmp       ax, 1
                           jne       no_brick1

                           CALL      ClearBrick


    not_in_col1:           
                           add       si, 2                             ; Move to the next rectangle
                           cmp       si, numCols
                           jne       collision1_loop2

    not_in_row1:           
                           add       di,2                              ;move 2 bytes to second element
                           cmp       di, numRows
                           jne       collision1_loop1

    no_brick1:             
                           pop       si
                           pop       di
                           pop       dx
                           pop       cx
                           pop       bx
                           pop       ax
                           ret
Collision1 endp

Collision1_2 proc
                           push      ax
                           push      bx
                           push      cx
                           push      dx
                           push      di
                           push      si

                           mov       di, 0                             ; di is row-index
    collision1_loop1_2:    
                           mov       si, 0                             ; si is col-index

                           mov       ax, rowStart_2[di]
                           sub       ax, ball_size_2
                           cmp       ax, ball_y_2
                           jg        not_in_row1_2

                           add       ax, rheight_2
                           add       ax, ball_size_2
                           cmp       ax, ball_y_2
                           jl        not_in_row1_2
    collision1_loop2_2:    

                           mov       ax, colStart1_2[si]
                           sub       ax, ball_size_2
                           cmp       ax, ball_x_2
                           jg        not_in_col1_2

                           add       ax, rwidth_2
                           add       ax, ball_size_2
                           cmp       ax, ball_x_2
                           jl        not_in_col1_2

                           mov       ax, di
                           mov       cx, numCols_2
                           mul       cx
                           mov       cx,2
                           div       cx
                           mov       bx, ax
                           add       bx, si
                           mov       ax, bricks_2[bx]
                           cmp       ax, 1
                           jne       no_brick1_2

                           CALL      ClearBrick_2


    not_in_col1_2:         
                           add       si, 2                             ; Move to the next rectangle
                           cmp       si, numCols_2
                           jne       collision1_loop2_2

    not_in_row1_2:         
                           add       di,2                              ;move 2 bytes to second element
                           cmp       di, numRows_2
                           jne       collision1_loop1_2

    no_brick1_2:           
                           pop       si
                           pop       di
                           pop       dx
                           pop       cx
                           pop       bx
                           pop       ax
                           ret
Collision1_2 endp

Collision2 proc
                           push      ax
                           push      bx
                           push      cx
                           push      dx
                           push      di
                           push      si

                           mov       di, 0                             ; di is row-index
    collision2_loop1:      
                           mov       si, 0                             ; si is col-index

                           mov       ax, rowStart[di]
                           sub       ax, ball_size
                           cmp       ax, ball_y
                           jg        not_in_row2

                           add       ax, rheight
                           add       ax, ball_size
                           cmp       ax, ball_y
                           jl        not_in_row2
    collision2_loop2:      

                           mov       ax, colStart2[si]
                           sub       ax, ball_size
                           cmp       ax, ball_x
                           jg        not_in_col2

                           add       ax, rwidth
                           add       ax, ball_size
                           cmp       ax, ball_x
                           jl        not_in_col2

                           mov       ax, di
                           mov       cx, numCols
                           mul       cx
                           mov       cx, 2
                           div       cx
                           mov       bx, ax
                           add       bx, si
                           mov       ax, bricks[bx]
                           cmp       ax, 1
                           jne       no_brick2

                           CALL      ClearBrick


    not_in_col2:           
                           add       si, 2                             ; Move to the next rectangle
                           cmp       si, numCols
                           jne       collision2_loop2

    not_in_row2:           
                           add       di,2                              ;move 2 bytes to second element
                           cmp       di, numRows
                           jne       collision2_loop1

    no_brick2:             
                           pop       si
                           pop       di
                           pop       dx
                           pop       cx
                           pop       bx
                           pop       ax
                           ret
Collision2 endp

Collision2_2 proc
                           push      ax
                           push      bx
                           push      cx
                           push      dx
                           push      di
                           push      si

                           mov       di, 0                             ; di is row-index
    collision2_loop1_2:    
                           mov       si, 0                             ; si is col-index

                           mov       ax, rowStart_2[di]
                           sub       ax, ball_size_2
                           cmp       ax, ball_y_2
                           jg        not_in_row2_2

                           add       ax, rheight_2
                           add       ax, ball_size_2
                           cmp       ax, ball_y_2
                           jl        not_in_row2_2
    collision2_loop2_2:    

                           mov       ax, colStart2_2[si]
                           sub       ax, ball_size_2
                           cmp       ax, ball_x_2
                           jg        not_in_col2_2

                           add       ax, rwidth_2
                           add       ax, ball_size_2
                           cmp       ax, ball_x_2
                           jl        not_in_col2_2

                           mov       ax, di
                           mov       cx, numCols_2
                           mul       cx
                           mov       cx, 2
                           div       cx
                           mov       bx, ax
                           add       bx, si
                           mov       ax, bricks_2[bx]
                           cmp       ax, 1
                           jne       no_brick2_2

                           CALL      ClearBrick_2


    not_in_col2_2:         
                           add       si, 2                             ; Move to the next rectangle
                           cmp       si, numCols_2
                           jne       collision2_loop2_2

    not_in_row2_2:         
                           add       di,2                              ;move 2 bytes to second element
                           cmp       di, numRows_2
                           jne       collision2_loop1_2

    no_brick2_2:           
                           pop       si
                           pop       di
                           pop       dx
                           pop       cx
                           pop       bx
                           pop       ax
                           ret
Collision2_2 endp

Collision3 proc
                           push      ax
                           push      bx
                           push      cx
                           push      dx
                           push      di
                           push      si

                           mov       di, 0                             ; di is row-index
    collision3_loop1:      
                           mov       si, 0                             ; si is col-index

                           mov       ax, rowStart[di]
                           sub       ax, ball_size
                           cmp       ax, ball_y
                           jg        not_in_row3

                           add       ax, rheight
                           add       ax, ball_size
                           cmp       ax, ball_y
                           jl        not_in_row3
    collision3_loop2:      

                           mov       ax, colStart3[si]
                           sub       ax, ball_size
                           cmp       ax, ball_x
                           jg        not_in_col3

                           add       ax, rwidth
                           add       ax, ball_size
                           cmp       ax, ball_x
                           jl        not_in_col3

                           mov       ax, di
                           mov       cx, numCols
                           mul       cx
                           mov       cx, 2
                           div       cx
                           mov       bx, ax
                           add       bx, si
                           mov       ax, bricks[bx]
                           cmp       ax, 1
                           jne       no_brick3

                           CALL      ClearBrick


    not_in_col3:           
                           add       si, 2                             ; Move to the next rectangle
                           cmp       si, numCols
                           jne       collision3_loop2

    not_in_row3:           
                           add       di,2                              ;move 2 bytes to second element
                           cmp       di, numRows
                           jne       collision3_loop1

    no_brick3:             
                           pop       si
                           pop       di
                           pop       dx
                           pop       cx
                           pop       bx
                           pop       ax
                           ret
Collision3 endp

Collision3_2 proc
                           push      ax
                           push      bx
                           push      cx
                           push      dx
                           push      di
                           push      si

                           mov       di, 0                             ; di is row-index
    collision3_loop1_2:    
                           mov       si, 0                             ; si is col-index

                           mov       ax, rowStart_2[di]
                           sub       ax, ball_size_2
                           cmp       ax, ball_y_2
                           jg        not_in_row3_2

                           add       ax, rheight_2
                           add       ax, ball_size_2
                           cmp       ax, ball_y_2
                           jl        not_in_row3_2
    collision3_loop2_2:    

                           mov       ax, colStart3_2[si]
                           sub       ax, ball_size_2
                           cmp       ax, ball_x_2
                           jg        not_in_col3_2

                           add       ax, rwidth_2
                           add       ax, ball_size_2
                           cmp       ax, ball_x_2
                           jl        not_in_col3_2

                           mov       ax, di
                           mov       cx, numCols_2
                           mul       cx
                           mov       cx, 2
                           div       cx
                           mov       bx, ax
                           add       bx, si
                           mov       ax, bricks_2[bx]
                           cmp       ax, 1
                           jne       no_brick3_2

                           CALL      ClearBrick_2


    not_in_col3_2:         
                           add       si, 2                             ; Move to the next rectangle
                           cmp       si, numCols_2
                           jne       collision3_loop2_2

    not_in_row3_2:         
                           add       di,2                              ;move 2 bytes to second element
                           cmp       di, numRows_2
                           jne       collision3_loop1_2

    no_brick3_2:           
                           pop       si
                           pop       di
                           pop       dx
                           pop       cx
                           pop       bx
                           pop       ax
                           ret
Collision3_2 endp

ClearBrick proc
                           push      ax
                           push      bx
                           push      cx
                           push      dx
                           push      di
                           push      si


                           CALL      beep
                           neg       ball_dy
                           mov       bricks[bx], 0
                           add       score, 1
                           mov       al, 0

                           cmp       selected_level, 1
                           je        clear_level1
                           cmp       selected_level, 2
                           je        clear_level2
                           cmp       selected_level, 3
                           je        clear_level3

    clear_level1:          
                           call      DrawRectangle1
                           cmp       score, score1
                           jne       same_lvl
                           call      ResetBricks
                           mov       selected_level, 2
                           call      ResetAll
                           jmp       same_lvl

    clear_level2:          
                           call      DrawRectangle2
                           cmp       score, score2
                           jne       same_lvl
                           call      ResetBricks
                           mov       selected_level, 3
                           call      ResetAll
                           jmp       same_lvl

    clear_level3:          
                           call      DrawRectangle3
                           cmp       score, score3
                           jne       same_lvl
                           call      ResetBricks
                           mov       selected_level, 3
                           mov       score, score2
                           call      ResetAll

    same_lvl:              
                           CALL      SpawnGift
                           
                           pop       si
                           pop       di
                           pop       dx
                           pop       cx
                           pop       bx
                           pop       ax

                           ret
ClearBrick endp

ClearBrick_2 proc
                           push      ax
                           push      bx
                           push      cx
                           push      dx
                           push      di
                           push      si


                           CALL      beep
                           neg       ball_dy_2

                           mov       bricks_2[bx], 0
                           add       score_2, 1
                           mov       al, 0

                           cmp       selected_level_2, 1
                           je        clear_level1_2
                           cmp       selected_level_2, 2
                           je        clear_level2_2
                           cmp       selected_level_2, 3
                           je        clear_level3_2

    clear_level1_2:        
                           call      DrawRectangle1_2
                           cmp       score_2, score1_2
                           jne       same_lvl_2
                           call      ResetBricks_2
                           mov       selected_level_2, 2
                           call      ResetAll_2
                           jmp       same_lvl_2

    clear_level2_2:        
                           call      DrawRectangle2_2
                           cmp       score_2, score2_2
                           jne       same_lvl_2
                           call      ResetBricks_2
                           mov       selected_level_2, 3
                           call      ResetAll_2
                           jmp       same_lvl_2

    clear_level3_2:        
                           call      DrawRectangle3_2
                           cmp       score_2, score3_2
                           jne       same_lvl_2
                           call      ResetBricks_2
                           mov       selected_level_2, 3
                           mov       score_2, score2_2
                           call      ResetAll_2

    same_lvl_2:            
                           CALL      SpawnGift_2
                           pop       si
                           pop       di
                           pop       dx
                           pop       cx
                           pop       bx
                           pop       ax

                           ret
ClearBrick_2 endp

RandomByte PROC
                           mov       ah, 00h
                           int       1Ah
                           xor       al, dh
                           ret
RandomByte ENDP

RandomByte_2 PROC
                           mov       ah, 00h
                           int       1Ah
                           xor       al, dh
                           ret
RandomByte_2 ENDP

SpawnGift PROC
                           cmp       [is_there_gift], 1
                           je        SkipActivation
                           mov       cl, gift_count                    ; Total number of gifts
                           mov       ch,0
                           mov       bx, current_gift                  ; Start checking from current_gift
                           xor       dx, 0                             ; Loop control (wrap-around)

    FindSlot:              
                           cmp       bx, cx                            ; Check if bx >= gift_count
                           jl        CheckSlot                         ; If within range, check slot

                           xor       bx, bx                            ; Wrap around to 0
                           inc       dx                                ; Increment loop counter
                           cmp       dx, 2                             ; Have we looped twice?
                           jge       NoSlotAvailable                   ; If yes, exit

    CheckSlot:             
                           cmp       [gift_active+bx], 0               ; Check if the gift is inactive
                           je        MaybeActivate
                           inc       bx                                ; Move to the next slot
                           jmp       FindSlot

    MaybeActivate:         
    ; Generate a random number to decide activation
                           push      cx
                           call      RandomByte
                           pop       cx
                           MOV AL, 1;
                           and       al, 1
                           cmp       al, 0
                           je        NoSlotAvailable

    ActivateGift:          
                           mov       ax, bx
                           shl       ax, 1
                           mov       si, ax
                           

                           mov       [gift_active+bx], 1               ; Activate the gift
                           mov       ax, ball_x
                           mov       gift_x, ax
                           mov       ax, ball_y
                           mov       gift_y, ax
                           mov       [is_there_gift],1

    ; Increment current_gift
                           inc       current_gift                      ; Increment current gift
                           cmp       current_gift, cx                  ; Check if it exceeds gift_count
                           jl        SkipWrapAround
                           mov       [current_gift],0
                           inc       current_gift_counter
                           cmp       current_gift_counter, 3
                           jne testfail
                           mov ah, 0
                           int 16h
                           testfail:

    SkipWrapAround:        
                           ret

    SkipActivation:        
                           inc       bx                                ; Move to the next slot
                           jmp       FindSlot

    NoSlotAvailable:       
                           ret
SpawnGift ENDP

SpawnGift_2 PROC
                           cmp       [is_there_gift_2], 1
                           je        SkipActivation_2
                           mov       cl, gift_count_2                  ; Total number of gifts
                           mov       ch,0
                           mov       bx, current_gift_2                ; Start checking from current_gift
                           xor       dx, 0                             ; Loop control (wrap-around)

    FindSlot_2:            
                           cmp       bx, cx                            ; Check if bx >= gift_count
                           jl        CheckSlot_2                       ; If within range, check slot

                           xor       bx, bx                            ; Wrap around to 0
                           inc       dx                                ; Increment loop counter
                           cmp       dx, 2                             ; Have we looped twice?
                           jge       NoSlotAvailable_2                 ; If yes, exit

    CheckSlot_2:           
                           cmp       [gift_active_2+bx], 0             ; Check if the gift is inactive
                           je        MaybeActivate_2
                           inc       bx                                ; Move to the next slot
                           jmp       FindSlot_2

    MaybeActivate_2:       
    ; Generate a random number to decide activation
                           push      cx
                           call      RandomByte_2
                           pop       cx
                           and       al, 1
                           cmp       al, 0
                           je        NoSlotAvailable_2

    ActivateGift_2:        
                           mov       ax, bx
                           shl       ax, 1
                           mov       si, ax

                           mov       [gift_active_2+bx], 1             ; Activate the gift
                           mov       ax, ball_x_2
                           mov       gift_x_2, ax
                           mov       ax, ball_y_2
                           mov       gift_y_2, ax
                           mov       [is_there_gift_2],1

    ; Increment current_gift
                           inc       current_gift_2                    ; Increment current gift
                           cmp       current_gift_2 ,cx                ; Check if it exceeds gift_count
                           jl        SkipWrapAround_2
                           mov       [current_gift_2],0
                                                      inc       current_gift_counter_2
                           cmp       current_gift_counter_2, 3
                           jne testfail_2
                           mov ah, 0
                           int 16h
                           testfail_2:

    SkipWrapAround_2:      
                           ret

    SkipActivation_2:      
                           inc       bx                                ; Move to the next slot
                           jmp       FindSlot_2

    NoSlotAvailable_2:     
                           ret
SpawnGift_2 ENDP



MAIN PROC
    MOV       AX, @DATA
    MOV       DS, AX

    MOV       AX, 4F02h
    MOV       BX, 103h
    INT       10h

    CALL      DrawLevel1
    CALL      DrawLevel1_2

    lea si, songNotes
    push si
gameLoop:

    CMP       inReset, 1
    JE        waitForReset1
    Collision selected_level
    CALL      DrawPadel
    CALL      MovePadel
    MOV       ball_color, 0
    CALL      DrawBall
    CALL      MoveBall
    MOV       BL, gift_ball_color
    MOV       ball_color, BL
    CALL      DrawBall
    CALL      GiftLogic_1
    JMP       skipPlayer1

waitForReset1:
    mov cx, 1000h
    waitloop:
    loop waitloop

    MOV       AH, 1
    INT       16h
    JNZ       resetPlayer1Done
    JMP       skipPlayer1

resetPlayer1Done:
    MOV       inReset, 0

skipPlayer1:


    CMP       inReset_2, 1
    JE        waitForReset2
    Collision_2 selected_level_2
    CALL      DrawPadel_2
    CALL      MovePadel_2
    MOV       ball_color_2, 0
    CALL      DrawBall_2
    CALL      MoveBall_2
    MOV       BL, gift_ball_color_2
    MOV       ball_color_2, BL
    CALL      GiftLogic_2
    JMP       skipPlayer2

waitForReset2:
    mov cx, 1000h
    waitloop_2:
    loop waitloop_2
    MOV       AH, 1
    INT       16h
    JNZ       resetPlayer2Done
    JMP       skipPlayer2

resetPlayer2Done:
    MOV       inReset_2, 0

skipPlayer2:
    CALL DrawBall_2
    JMP gameLoop                     ; Restart the song from the beginning
    ; :( too hard


    MOV       AX, 4C00h
    INT       21h
MAIN ENDP




beep proc
                           push      ax
                           push      bx
                           push      cx
                           push      dx
                           cmp       [gift_ball_color],4
                           jz        no_reflect


    no_reflect:            mov       al, 182                           ; Prepare the speaker for the
                           out       43h, al                           ;  note.
                           mov       ax, 400                           ; Frequency number (in decimal)
    ;  for middle C.
                           out       42h, al                           ; Output low byte.
                           mov       al, ah                            ; Output high byte.
                           out       42h, al
                           in        al, 61h                           ; Turn on note (get value from
    ;  port 61h).
                           or        al, 00000011b                     ; Set bits 1 and 0.
                           out       61h, al                           ; Send new value.
                           mov       bx, 2                             ; Pause for duration of note.
.pause1:
                           mov       cx, 65535
.pause2:
                           dec       cx
                           jne       .pause2
                           dec       bx
                           jne       .pause1
                           in        al, 61h                           ; Turn off note (get value from
    ;  port 61h).
                           and       al, 11111100b                     ; Reset bits 1 and 0.
                           out       61h, al                           ; Send new value.

                           pop       dx
                           pop       cx
                           pop       bx
                           pop       ax

                        ret
beep endp
;description

GiftLogic_1 PROC
                           mov       cl, gift_count
                           cmp       current_gift_counter, cl
                           jl        reset
                           mov       cl ,0
                           mov       current_gift_counter, cl
    reset:                 
                           
                           mov       bl,current_gift_counter
                           mov       bh,0


                           mov       gift_color, 0
                           mov       bow_color, 0
                           mov       ribbon_color, 0


                           CALL      DrawGift

                           mov       gift_color, 0
                           mov       bow_color, 0
                           mov       ribbon_color, 0

                           
                           CALL      MoveGift



                           mov       al,[gift_colors_list+bx]
                           mov       gift_color, al
                           mov       al,[gift_ribbon_list+bx]
                           mov       bow_color, al
                           mov       ribbon_color, al



                           CALL      DrawGift  



                           ;inc       current_gift_counter
                           cmp       gift_ball_color, 2
                           je        wait_30

                           inc       [gift_timer]
                           mov       ax, [gift_timer]
                           cmp       ax, 10000
                           jb        wait_30
                           mov       gift_ball_color, 2
                           mov       [padel_width],50

                           mov       gift_timer, 0
                        
    wait_30:  
    ret
GiftLogic_1 ENDP

GiftLogic_2 PROC
                           mov       cl, gift_count_2
                           cmp       current_gift_counter_2, cl
                           jl        reset_2
                           mov       cl ,0
                           mov       current_gift_counter_2,cl
    reset_2:                 
                           
                           mov       bl,current_gift_counter_2
                           mov       bh,0

                           mov       gift_color_2, 0
                           mov       bow_color_2, 0
                           mov       ribbon_color_2, 0
                           CALL      DrawGift_2

                           CALL      MoveGift_2
                           mov       al,[gift_colors_list_2+bx]
                           mov       gift_color_2, al
                           mov       al,[gift_ribbon_list_2+bx]
                           mov       bow_color_2, al
                           mov       ribbon_color_2, al
                           
                           CALL      DrawGift_2


                       

                           ;inc       current_gift_counter_2
                           cmp       gift_ball_color_2, 2
                           je        wait_30_2

                           inc       [gift_timer_2]
                           mov       ax, [gift_timer_2]
                           cmp       ax, 10000
                           jb        wait_30_2
                           mov       gift_ball_color_2, 2
                           mov       [padel_width_2],50

                           mov       gift_timer_2, 0
                        
    wait_30_2:  
    ret
GiftLogic_2 ENDP

END MAIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; CheckCollision proc
    ;                         push ax
    ;                         push bx
    ;                         push cx
    ;                         push dx

    ;                         mov  ax, rowStart[di]
    ;                         sub  ax, ball_size
    ;                         cmp  ax, ball_y
    ;                         jg   no_collision

    ;                         add  ax, rheight
    ;                         add  ax, ball_size
    ;                         cmp  ax, ball_y
    ;                         jl   no_collision

    ;                         mov  ax, colStart[si]
    ;                         sub  ax, ball_size
    ;                         cmp  ax, ball_x
    ;                         jg   no_collision

    ;                         add  ax, rwidth
    ;                         add  ax, ball_size
    ;                         cmp  ax, ball_x
    ;                         jl   no_collision
                        
    ;                         mov  ax, di
    ;                         mov  cx, 7
    ;                         mul  cx
    ;                         mov  bx, ax
    ;                         add  bx, si
    ;                         mov  bricks[bx], 0
    ;                         CALL beep
    ;                         CALL ClearBrick

    ;     no_collision:
    ;                         pop  dx
    ;                         pop  cx
    ;                         pop  bx
    ;                         pop  ax
    ;                         ret
    ; CheckCollision end