
.MODEL small
.STACK 100h

.DATA
    padel_x1            DW  135
    padel_x2            DW  185
    padel_y1            DW  187
    padel_y2            DW  190
    padel_color         db  4
    padel_speed         equ 7
    padel_width         dw 50

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

    ;Bricks number of rows and columns
    numRows             dw  8                                                                                                  ; 2 * real number of rows
    rowStart            dw  5, 20, 35, 50, 65, 80, 95, 110, 125, 140

    numCols             dw  14                                                                                                 ; 2 * real number of cols
    colStart1           dw  5, 50, 95, 140, 185, 230, 275, 320, 365, 410
    colStart2           dw  5, 30, 55, 80, 105, 130, 155, 180, 205, 230, 255, 280
    colStart3           dw  5, 20, 35, 50, 65, 80, 95, 110, 125, 140, 155, 170, 185, 200, 215, 230, 245, 260, 275, 290, 305

    dummycol            dw  ?
    dummyrow            dw  ?
    ;Bricks existence
    bricks              dw  264 DUP(1)                                                                                         ; max num of bricks in a level (lvl 3)                                                                                                                                                                                                                                                                                              ; 2 * numRows * numCols

    ;Brick dimensions
    rwidth              dw  40
    rheight             dw  10

    ;score & level
    score               dw  0
    selected_level      db  0

    score1              equ 28                                                                                                 ; 4 * 7
    score2              equ 112                                                                                                ; 4 * 7 + 7 * 12
    score3              equ 322                                                                                                ; 4 * 7 + 7 * 12 + 10 * 21


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;Brick gifts
    gift_dy             dw  2
    gift_size           equ 6
    gift_speed          equ 40
    gift_color          db  ?
    ribbon_color        db  ?
    bow_color           db  ?
    gift_count          dw  5
    backgournd_color    db  5 dup(0)
    gift_active         db  5 dup(0)
    gift_x              dw  5
    gift_y              dw  5
    gift_counter        dw  gift_speed
    gift_colors_list    db  2,5,9,14,15
    gift_ribbon_list    db  4,11,2,4,5
    gift_ball_color     db  2
    gift_timer          dw  0
    current_gift        dw  0
    is_there_gift       db  0
    



.CODE

ClearScreen PROC
                         mov       ax, 0A000h
                         mov       es, ax
                         xor       di, di
                         mov       al, 0
                         mov       cx, 64000
                         rep       stosb
                         RET
ClearScreen ENDP

DrawPadel PROC
                         mov       cx, padel_x1
                         mov       dx, padel_y1
                         mov       al, padel_color
                         mov       ah, 0ch
    draw_top:            
                         int       10h
                         inc       cx
                         cmp       cx, padel_x2
                         jnz       draw_top

                         mov       cx, padel_x1
                         mov       dx, padel_y1
    draw_left:           
                         int       10h
                         inc       dx
                         cmp       dx, padel_y2
                         jnz       draw_left

                         mov       cx, padel_x2
                         mov       dx, padel_y1
    draw_right:          
                         int       10h
                         inc       dx
                         cmp       dx, padel_y2
                         jnz       draw_right

                         mov       cx, padel_x1
                         mov       dx, padel_y2
    draw_bottom:         
                         int       10h
                         inc       cx
                         cmp       cx, padel_x2
                         jnz       draw_bottom

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


MovePadel PROC
                         mov       ax, 3
                         int       33h

                         shr       cx, 1
                         mov       si, cx
                         sub       si, 25

                         cmp       si, padel_x1
                         je        no_move

                         push      cx
                         mov       padel_color, 0
                         call      DrawPadel
                         pop       cx

                         mov       padel_x1, si

                         add       si, padel_width
                         mov       padel_x2, si


                         mov       padel_color, 4
                         call      DrawPadel

    no_move:             
                         RET
MovePadel ENDP

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

                         cmp       ball_x, 10
                         jle       ball_left_edge

                         cmp       ball_x, 315
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
                         cmp       ball_y, 10
                         jle       ball_top_edge

                         cmp       ball_y, 190
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

ResetAll PROC
                         mov       ball_x, 160
                         mov       ball_y, 180
                         mov       ball_dx, ball_og_speed
                         mov       ball_dy, ball_og_speed
                         mov       padel_x1, 135
                         mov       padel_x2, 185
                         mov       padel_y1, 187
                         mov       padel_y2, 190
                         mov       [gift_ball_color],2
                         mov       [gift_timer],0
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
                         inc       bx
                         cmp       bx,[gift_count]
                         jne       ResetAllGifts

                         mov       ah, 0
                         int       16h
                         RET
ResetAll ENDP

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

DrawGift PROC
                         cmp       [gift_active+bx], 0
                         push      bx                              ; Check if the gift is active
                         je        SkipDrawing                     ; Skip if not active


    ; Use calculated offsets to access gift_x_list and gift_y_list
                         mov       cx, gift_x                      ; Get X position of the gift
                         mov       dx, gift_y                      ; Get Y position of the gift
                         mov       bx, gift_size                   ; Load the gift size
                         push      cx
                         push      dx
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


MoveGift PROC
                         push      bx
                         mov       cx, gift_count
                         xor       bx, bx
                        

    LoopMoveGifts:       
                         cmp       bx, cx
                         jge       EndMove


    ; Check if gift is active
                         cmp       [gift_active+bx], 0             ; Is the gift active?
                         je        SkipGift

    ; Decrement counter
                         dec       [gift_counter]                  ; Decrement gift's counter
                         jnz       SkipGift
                        
                         push      cx
                         push      ax
                         mov       gift_color, 0
                         mov       bow_color, 0
                         mov       ribbon_color, 0

                         CALL      DrawGift
                         pop       ax
                         pop       cx

    ; Reset counter
                         mov       ax, gift_speed
                         mov       [gift_counter], ax

    ; Move gift down
                         mov       ax, gift_y
                         add       ax, gift_dy
                         mov       [gift_y], ax                    ; Update Y positionFre

    continue_move_gift:  
                         cmp       ax, 190
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
                        
                         cmp       [gift_colors_list+bx],2                  ; Check if gift_color is 2
                         je        SetColor4                       ; Jump to set gift_ball_color to 4

                         cmp       [gift_colors_list+bx], 5                   ; Check if gift_color is 5
                         je        SetColor14                      ; Jump to set gift_ball_color to 14

                         cmp       [gift_colors_list+bx], 9                   ; Check if gift_color is 9
                         je        SetColor5                       ; Jump to set gift_ball_color to 5

                         cmp       [gift_colors_list+bx], 14                  ; Check if gift_color is 14
                         je        SetColor1                       ; Jump to set gift_ball_color to 1

                         cmp       [gift_colors_list+bx], 15                  ; Check if gift_color is 15
                         je        SetColor13                      ; Jump to set gift_ball_color to 13

                         jmp       EndSetColor                     ; Skip to end if no condition matches

    SetColor4:           
                         mov       [gift_ball_color], 4
                         jmp       EndSetColor                     ; Jump to end

    SetColor14:          
                         mov       [gift_ball_color], 14
                         mov [padel_width],70
                         jmp       EndSetColor                     ; Jump to end

    SetColor5:           
                         mov       [gift_ball_color], 5
                         mov [padel_width],30
                         jmp       EndSetColor                     ; Jump to end

    SetColor1:           
                         mov       [gift_ball_color], 1
                         mov padel_x1,155
                         mov padel_x2, 165
                         jmp       EndSetColor                     ; Jump to end

    SetColor13:          
                         mov       [gift_ball_color], 13

    EndSetColor:         
                         mov       gift_timer, 0                   ; Reset gift_timer


    SkipGift:            
                         inc       bx
                         jmp       LoopMoveGifts

    EndMove:             
                         pop       bx
                         ret
MoveGift ENDP


DrawRectangle1 PROC
    ;to calculate final column
                         mov       dx,rowStart[di]                 ;set row start of each rectangle
                         mov       ah,0ch                          ;command to draw pixel

                         mov       bx, rheight                     ; bx = height
                         add       bx, dx                          ; bx = height + row = final row to draw in
                         mov       dummyrow, bx                    ;dummyrow now holds the final row

    ;to calculate final column
                         mov       bx, rwidth                      ;bx = rectangle wdith
                         add       bx, colStart1[si]               ;bx += column start
                         mov       dummycol, bx                    ;dummycol now has the final column to draw
        
    height_loop:                                                   ;draws pixels along the height (rows)
                         mov       cx,colStart1[si]

    width_loop:          int       10h                             ;draws pixels along the width (columns) for one row
                         inc       cx
                         cmp       cx, dummycol
                         jnz       width_loop


                         inc       dx
                         cmp       dx, dummyrow
                         jnz       height_loop
                         ret
DrawRectangle1 ENDP

DrawRectangle2 PROC
    ;to calculate final column
                         mov       dx,rowStart[di]                 ;set row start of each rectangle
                         mov       ah,0ch                          ;command to draw pixel

                         mov       bx, rheight                     ; bx = height
                         add       bx, dx                          ; bx = height + row = final row to draw in
                         mov       dummyrow, bx                    ;dummyrow now holds the final row

    ;to calculate final column
                         mov       bx, rwidth                      ;bx = rectangle wdith
                         add       bx, colStart2[si]               ;bx += column start
                         mov       dummycol, bx                    ;dummycol now has the final column to draw
        
    height2_loop:                                                  ;draws pixels along the height (rows)
                         mov       cx,colStart2[si]

    width2_loop:         int       10h                             ;draws pixels along the width (columns) for one row
                         inc       cx
                         cmp       cx, dummycol
                         jnz       width2_loop


                         inc       dx
                         cmp       dx, dummyrow
                         jnz       height2_loop
                         ret
DrawRectangle2 ENDP

DrawRectangle3 PROC
    ;to calculate final column
                         mov       dx,rowStart[di]                 ;set row start of each rectangle
                         mov       ah,0ch                          ;command to draw pixel

                         mov       bx, rheight                     ; bx = height
                         add       bx, dx                          ; bx = height + row = final row to draw in
                         mov       dummyrow, bx                    ;dummyrow now holds the final row

    ;to calculate final column
                         mov       bx, rwidth                      ;bx = rectangle wdith
                         add       bx, colStart3[si]               ;bx += column start
                         mov       dummycol, bx                    ;dummycol now has the final column to draw
        
    height3_loop:                                                  ;draws pixels along the height (rows)
                         mov       cx,colStart3[si]

    width3_loop:         int       10h                             ;draws pixels along the width (columns) for one row
                         inc       cx
                         cmp       cx, dummycol
                         jnz       width3_loop


                         inc       dx
                         cmp       dx, dummyrow
                         jnz       height3_loop
                         ret
DrawRectangle3 ENDP

DrawRow proc
                         mov       si, 0                           ; si is col-index
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
                         inc       al                              ;change color of each rectangle
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
                         add       si, 2                           ; Move to the next rectangle
                         cmp       si, numCols
                         jnz       draw_loop
                         ret
DrawRow ENDP

DrawLevel1 proc
                         mov       di, 0                           ; di is row-index
                         mov       numRows, 8
                         mov       numCols, 14
                         mov       difficulty, 01fh
                         mov       original_difficulty, 01fh
                         mov       selected_level, 1
    rows_loop:           
                         call      DrawRow
                         add       di,2                            ;move 2 bytes to second element
                         cmp       di, numRows
                         jnz       rows_loop
                         ret
DrawLevel1 endp

DrawLevel2 proc
                         mov       di, 0                           ; di is row-index
                         mov       numRows, 14
                         mov       numCols, 24
                         mov       rwidth, 20
                         mov       difficulty, 0dh
                         mov       original_difficulty, 0dh
                         mov       selected_level, 2


    lvl2:                
                         call      DrawRow
                         add       di,2                            ;move 2 bytes to second element
                         cmp       di, numRows
                         jnz       lvl2
                         ret

DrawLevel2 endp

DrawLevel3 proc
                         mov       di, 0                           ; di is row-index
                         mov       numRows, 20
                         mov       numCols, 42
                         mov       rwidth, 10
                         mov       difficulty, 09h
                         mov       original_difficulty, 09h
                         mov       selected_level, 3

    lvl3:                
                         call      DrawRow
                         add       di,2                            ;move 2 bytes to second element
                         cmp       di, numRows
                         jnz       lvl3
                         ret
DrawLevel3 endp

Collision macro lvl
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

Collision1 proc
                         push      ax
                         push      bx
                         push      cx
                         push      dx
                         push      di
                         push      si

                         mov       di, 0                           ; di is row-index
    collision1_loop1:    
                         mov       si, 0                           ; si is col-index

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
                         add       si, 2                           ; Move to the next rectangle
                         cmp       si, numCols
                         jne       collision1_loop2

    not_in_row1:         
                         add       di,2                            ;move 2 bytes to second element
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

Collision2 proc
                         push      ax
                         push      bx
                         push      cx
                         push      dx
                         push      di
                         push      si

                         mov       di, 0                           ; di is row-index
    collision2_loop1:    
                         mov       si, 0                           ; si is col-index

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
                         add       si, 2                           ; Move to the next rectangle
                         cmp       si, numCols
                         jne       collision2_loop2

    not_in_row2:         
                         add       di,2                            ;move 2 bytes to second element
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

Collision3 proc
                         push      ax
                         push      bx
                         push      cx
                         push      dx
                         push      di
                         push      si

                         mov       di, 0                           ; di is row-index
    collision3_loop1:    
                         mov       si, 0                           ; si is col-index

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
                         add       si, 2                           ; Move to the next rectangle
                         cmp       si, numCols
                         jne       collision3_loop2

    not_in_row3:         
                         add       di,2                            ;move 2 bytes to second element
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

ClearBrick proc
                         push      ax
                         push      bx
                         push      cx
                         push      dx
                         push      di
                         push      si


                         CALL      beep
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

RandomByte PROC
                         mov       ah, 00h
                         int       1Ah
                         xor       al, dh
                         ret
RandomByte ENDP

SpawnGift PROC
                         cmp       [is_there_gift], 1
                         je        SkipActivation
                         mov       cx, gift_count                  ; Total number of gifts
                         mov       bx, current_gift                ; Start checking from current_gift
                         xor       dx, 0                           ; Loop control (wrap-around)

    FindSlot:            
                         cmp       bx, cx                          ; Check if bx >= gift_count
                         jl        CheckSlot                       ; If within range, check slot

                         xor       bx, bx                          ; Wrap around to 0
                         inc       dx                              ; Increment loop counter
                         cmp       dx, 2                           ; Have we looped twice?
                         jge       NoSlotAvailable                 ; If yes, exit

    CheckSlot:           
                         cmp       [gift_active+bx], 0             ; Check if the gift is inactive
                         je        MaybeActivate
                         inc       bx                              ; Move to the next slot
                         jmp       FindSlot

    MaybeActivate:       
    ; Generate a random number to decide activation
                         push      cx
                         call      RandomByte
                         pop       cx
                         and       al, 1
                         cmp       al, 0
                         je        NoSlotAvailable

    ActivateGift:        
                         mov       ax, bx
                         shl       ax, 1
                         mov       si, ax

                         mov       [gift_active+bx], 1             ; Activate the gift
                         mov       ax, ball_x
                         mov       gift_x, ax
                         mov       ax, ball_y
                         mov       gift_y, ax
                         mov       [is_there_gift],1

    ; Increment current_gift
                         inc       current_gift                    ; Increment current gift
                         cmp       current_gift, cx                ; Check if it exceeds gift_count
                         jl        SkipWrapAround
                         mov       [current_gift],0

    SkipWrapAround:      
                         ret

    SkipActivation:      
                         inc       bx                              ; Move to the next slot
                         jmp       FindSlot

    NoSlotAvailable:     
                         ret
SpawnGift ENDP



MAIN PROC
                         MOV       AX, @DATA
                         MOV       DS, AX

                         MOV       AH, 0                           ;following 3 lines to enter graphic mode
                         MOV       AL, 13h
                         INT       10h
    ; MOV  AX, 4F02h                              ; VESA function to set mode
    ; MOV  BX, 103h                               ; Mode 103h = 800x600 with 256 colors
    ; INT  10h

                         call      DrawLevel1
    ;call DrawLevel2
    ;call DrawLevel3

    gameLoop:            
                         Collision selected_level                  ; a macro to determine which collision proc to call based on the current level
                         CALL      DrawPadel
                         CALL      MovePadel
                         mov       ball_color, 0
                         call      DrawBall
                         call      MoveBall
                         mov       bl, gift_ball_color
                         mov       ball_color, bl

                         call      DrawBall
                         pop       bx
                         mov       cx, gift_count
                         cmp       bx, cx
                         jl        reset
                         xor       bx,bx
    reset:               

                        
                         CALL      MoveGift
                         mov       al,[gift_colors_list+bx]
                         mov       gift_color, al
                         mov       al,[gift_ribbon_list+bx]
                         mov       bow_color, al
                         mov       ribbon_color, al

                         CALL      DrawGift
                       

                         inc       bx
                         push      bx
                         cmp       gift_ball_color, 2
                         je        wait_30

                         inc       [gift_timer]
                         mov       ax, [gift_timer]
                         cmp       ax, 10000
                         jb        wait_30
                         mov       gift_ball_color, 2
                         mov [padel_width],50

                         mov       gift_timer, 0
                        
    wait_30:             

                        

                         JMP       gameLoop

                         MOV       AX, 4C00h
                         INT       21h
MAIN ENDP

beep proc
                         push      ax
                         push      bx
                         push      cx
                         push      dx
                         cmp       [gift_ball_color],4
                         jz       no_reflect
                         neg       ball_dy
    no_reflect:          mov       al, 182                         ; Prepare the speaker for the
                         out       43h, al                         ;  note.
                         mov       ax, 400                         ; Frequency number (in decimal)
    ;  for middle C.
                         out       42h, al                         ; Output low byte.
                         mov       al, ah                          ; Output high byte.
                         out       42h, al
                         in        al, 61h                         ; Turn on note (get value from
    ;  port 61h).
                         or        al, 00000011b                   ; Set bits 1 and 0.
                         out       61h, al                         ; Send new value.
                         mov       bx, 2                           ; Pause for duration of note.
.pause1:
                         mov       cx, 65535
.pause2:
                         dec       cx
                         jne       .pause2
                         dec       bx
                         jne       .pause1
                         in        al, 61h                         ; Turn off note (get value from
    ;  port 61h).
                         and       al, 11111100b                   ; Reset bits 1 and 0.
                         out       61h, al                         ; Send new value.

                         pop       dx
                         pop       cx
                         pop       bx
                         pop       ax

                         ret
beep endp

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
    ; CheckCollision endp