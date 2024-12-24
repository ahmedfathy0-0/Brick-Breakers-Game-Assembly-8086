    PUBLIC DrawGift,MoveGift,RandomByte,SpawnGift

    PUBLIC gift_dy               
    PUBLIC gift_color            
    PUBLIC ribbon_color          
    PUBLIC bow_color             
    PUBLIC gift_count            
    PUBLIC backgournd_color       
    PUBLIC gift_active            
    PUBLIC gift_x                
    PUBLIC gift_y                
    PUBLIC gift_counter          
    PUBLIC gift_colors_list      
    PUBLIC gift_ribbon_list      
    PUBLIC gift_ball_color       
    PUBLIC gift_timer            
    PUBLIC current_gift          
    PUBLIC is_there_gift            
    PUBLIC current_gift_counter 

    EXTRN DisplayLives:FAR
    EXTRN DrawPadel:FAR


    EXTRN padel_x1:WORD
    EXTRN padel_x2:WORD
    EXTRN padel_y1:WORD 
    EXTRN padel_y2:WORD
    EXTRN ball_x :WORD               
    EXTRN ball_y :WORD
    EXTRN padel_width:WORD
    EXTRN padel_color:BYTE
    EXTRN display_lives:BYTE
 





 

.MODEL small
.STACK 100h

.DATA
        ;Brick gifts
    gift_dy               dw  2
    gift_size             equ 6
    gift_speed            equ 10
    gift_color            db  ?
    ribbon_color          db  ?
    bow_color             db  ?
    gift_count            dw  5
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
    current_gift_counter  dw  0
    
    ball_size        equ 3



.CODE
DrawGift PROC FAR
                         cmp       [gift_active + bx], 0
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


MoveGift PROC FAR
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
                         cmp       ax, 590
                         jl        check_gift_collision
                         mov        [gift_active+bx], 0
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
                         mov        [gift_active+bx], 0
                         mov       [is_there_gift],0
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
                         mov       [padel_width],80
                         jmp       EndSetColor                     ; Jump to end

    SetColor5:           
                         mov       [gift_ball_color], 5
                         mov        [padel_color],0
                         CALL       DrawPadel
                         mov        [padel_color],4
                         mov       [padel_width],20
                         jmp       EndSetColor                     ; Jump to end

    SetColor1:           
                         mov       [gift_ball_color], 1
                         jmp       EndSetColor                     ; Jump to end

    SetColor13:          
                         mov       [gift_ball_color], 13
                         inc       display_lives
                         call      DisplayLives
                         

    EndSetColor:         
                         mov       gift_timer, 0                   ; Reset gift_timer


    SkipGift:            
                         inc       bx
                         jmp       LoopMoveGifts

    EndMove:             
                         pop       bx
                         ret
MoveGift ENDP

RandomByte PROC FAR
                         mov       ah, 00h
                         int       1Ah
                         xor       al, dh
                         ret
RandomByte ENDP

SpawnGift PROC FAR
                         cmp       [is_there_gift], 1
                         je        SkipActivation
                         mov       cx, gift_count                  ; Total number of gifts
                         mov       bx, current_gift                ; Start checking from current_gift
                        
                         

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
    NoSlotAvailable:     
                         ret
SpawnGift ENDP

ret

END    