INCLUDE macros.inc
PUBLIC DrawLevel1,DrawLevel1_2,DrawLevel2,DrawLevel2_2,DrawLevel3,DrawLevel3_2
PUBLIC Collision1,Collision1_2,Collision2,Collision2_2,Collision3,Collision3_2
PUBLIC selected_level
PUBLIC selected_level_2
EXTRN ResetAll:FAR 
EXTRN ResetAll_2:FAR
EXTRN SpawnGift:FAR
EXTRN beep:FAR
EXTRN DisplayScore:FAR
EXTRN DisplayScore_2:FAR
EXTRN GameEnd:FAR


EXTRN score:WORD
EXTRN score_2:WORD
EXTRN display_score:WORD
EXTRN display_score_2:WORD
EXTRN difficulty:BYTE
EXTRN original_difficulty:BYTE
EXTRN difficulty_2:BYTE
EXTRN original_difficulty_2:BYTE
EXTRN ball_x :WORD               
EXTRN ball_y :WORD 
EXTRN ball_x_2 :WORD               
EXTRN ball_y_2 :WORD 
EXTRN gift_ball_color :BYTE  
EXTRN gift_ball_color_2: BYTE
EXTRN ball_dy :WORD
EXTRN ball_dy_2 :WORD   



 
 

.MODEL small
.STACK 100h

.DATA
        
      ;Bricks number of rows and columns
    score1_2         equ 28                                                                                                              ; 4 * 7
    score2_2         equ 112                                                                                                             ; 4 * 7 + 7 * 12
    score3_2         equ 332 
    score1           equ 28                                                                                                              ; 4 * 7
    score2           equ 112                                                                                                             ; 4 * 7 + 7 * 12
    score3           equ 332                                                                                                             ; 4 * 7 + 7 * 12 + 10 * 21
 
    ball_size        equ 3 
    ball_size_2      equ 3
    numRows          dw  8                                                                                                               ; 2 * real number of rows
    numRows1         equ 8
    numRows2         equ 14
    numRows3         equ 20
    rowStart         dw  205, 230, 255, 280, 305, 330, 355, 380, 405, 430

    numCols          dw  14                                                                                                              ; 2 * real number of cols
    numCols1         equ 14
    numCols2         equ 24
    numCols3         equ 44
    colStart1        dw  6, 62, 118, 174, 230, 286, 342
    colStart2        dw  3, 36, 69, 102, 135, 168, 201, 234, 267, 300, 333, 366
    colStart3        dw  3, 21, 39, 57, 75, 93, 111, 129, 147, 165, 183, 201, 219, 237, 255, 273, 291, 309, 327, 345, 363, 381

    dummycol         dw  ?
    dummyrow         dw  ?
    
    bricks           dw  320 DUP(1)                                                                                                      ; max num of bricks in a level (lvl 3)                                                                                                                                                                                                                                                                                              ; 2 * numRows * numCols

    ;Brick dimensions
    rwidth           dw  50
    rheight          dw  20

    ;score & level
    selected_level   db  0
 
    
    ;Bricks number of rows and columns
    numRows_2        dw  8                                                                                                               ; 2 * real number of rows
    numRows1_2       equ 8
    numRows2_2       equ 14
    numRows3_2       equ 20
    rowStart_2       dw  205, 230, 255, 280, 305, 330, 355, 380, 405, 430

    numCols_2        dw  14                                                                                                              ; 2 * real number of cols
    numCols1_2       equ 14
    numCols2_2       equ 24
    numCols3_2       equ 44
    colStart1_2      dw  406, 462, 518, 574, 630, 686, 742
    colStart2_2      dw  403, 436, 469, 502, 535, 568, 601, 634, 667, 700, 733, 766
    colStart3_2      dw  403, 421, 439, 457, 475, 493, 511, 529, 547, 565, 583, 601, 619, 637, 655, 673, 691, 709, 727, 745, 763, 781

    dummycol_2       dw  ?
    dummyrow_2       dw  ?
    ;Bricks existence
    bricks_2         dw  320 DUP(1)                                                                                                      ; max num of bricks in a level (lvl 3)                                                                                                                                                                                                                                                                                              ; 2 * numRows * numCols

    ;Brick dimensions
    rwidth_2         dw  50
    rheight_2        dw  20

    ;score & level
    selected_level_2 db  0




.CODE

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

DrawLevel1  proc FAR
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

DrawLevel1_2  proc FAR
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

DrawLevel2  proc FAR
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

DrawLevel2_2  proc FAR
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

DrawLevel3  proc FAR
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

DrawLevel3_2  proc FAR
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
                           
                           cmp       [gift_ball_color],1
                           jnz        skipdouble_score
                           add        display_score, 1
                skipdouble_score:
                           inc       display_score
                           CALL      DisplayScore
                           CALL      beep
                           cmp       [gift_ball_color],4
                            jnz       no_reflect
                            neg       ball_dy
                            no_reflect:
                           neg       ball_dy
                           mov       bricks[bx], 0
                           inc       score

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
                           CALL      GameEnd

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

                           cmp       [gift_ball_color_2],1
                           jnz        skipdouble_score_2
                           add        display_score_2, 1
                skipdouble_score_2:
                           add       display_score_2, 1
                           CALL      DisplayScore_2
                           CALL      beep
                           cmp       [gift_ball_color_2],4
                            jnz       no_reflect_2
                            neg       ball_dy_2
                            no_reflect_2:
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
                          ; CALL      SpawnGift_2
                           pop       si
                           pop       di
                           pop       dx
                           pop       cx
                           pop       bx
                           pop       ax

                           ret
ClearBrick_2 endp


ret

END