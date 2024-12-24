    INCLUDE macros.inc
    EXTRN DrawPadel:FAR
    EXTRN DrawPadel_2:FAR
    EXTRN MovePadel:FAR
    EXTRN MovePadel_2:FAR
    EXTRN DrawBall:FAR
    EXTRN DrawBall_2:FAR
    EXTRN MoveBall:FAR
    EXTRN MoveBall_2:FAR
    EXTRN DrawGift:FAR
    EXTRN MoveGift:FAR
    EXTRN SpawnGift:FAR
    EXTRN RandomByte:FAR
    EXTRN DrawLevel1:FAR
    EXTRN DrawLevel1_2:FAR
    EXTRN DrawLevel2:FAR
    EXTRN DrawLevel2_2:FAR
    EXTRN DrawLevel3:FAR
    EXTRN DrawLevel3_2:FAR
    EXTRN Collision1:FAR
    EXTRN Collision2:FAR
    EXTRN Collision3:FAR
    EXTRN Collision1_2:FAR
    EXTRN Collision2_2:FAR
    EXTRN Collision3_2:FAR
    EXTRN DisplayScore:FAR
    EXTRN DisplayScore_2:FAR
    EXTRN DisplayLives:FAR
    EXTRN DisplayLives_2:FAR

    



    EXTRN padel_x:WORD
    EXTRN padel_x1:WORD
    EXTRN padel_x2:WORD
    EXTRN padel_y1:WORD 
    EXTRN padel_y2:WORD   
    EXTRN padel_color:BYTE
    EXTRN padel_width:WORD

    EXTRN padel_x_2  :WORD   
    EXTRN padel_x1_2 :WORD   
    EXTRN padel_x2_2 :WORD   
    EXTRN padel_y1_2 :WORD   
    EXTRN padel_y2_2 :WORD   
    EXTRN padel_color_2 :BYTE
    EXTRN padel_width_2 :WORD
    EXTRN char :BYTE

    EXTRN ball_x :WORD               
    EXTRN ball_y :WORD               
    EXTRN ball_dx :WORD              
    EXTRN ball_dy :WORD             
    EXTRN ball_color :BYTE          
    EXTRN difficulty  :BYTE          
    EXTRN original_difficulty :BYTE 
    
    EXTRN ball_x_2 :WORD               
    EXTRN ball_y_2 :WORD               
    EXTRN ball_dx_2 :WORD              
    EXTRN ball_dy_2 :WORD             
    EXTRN ball_color_2 :BYTE          
    EXTRN difficulty_2  :BYTE          
    EXTRN original_difficulty_2 :BYTE 

    EXTRN gift_dy :WORD                   
    EXTRN gift_color :BYTE          
    EXTRN ribbon_color :BYTE        
    EXTRN bow_color :BYTE           
    EXTRN gift_count :WORD          
    EXTRN backgournd_color :BYTE    
    EXTRN gift_active :BYTE         
    EXTRN gift_x :WORD              
    EXTRN gift_y :WORD              
    EXTRN gift_counter :WORD        
    EXTRN gift_colors_list :BYTE    
    EXTRN gift_ribbon_list :BYTE    
    EXTRN gift_ball_color :BYTE     
    EXTRN gift_timer :WORD          
    EXTRN current_gift :WORD        
    EXTRN is_there_gift :BYTE       
    EXTRN current_gift_counter :WORD

    EXTRN display_lives :BYTE
    EXTRN display_lives_2 :BYTE


    EXTRN selected_level :BYTE
    EXTRN selected_level_2 :BYTE

    PUBLIC  ResetAll,ResetAll_2,beep



.MODEL small
.STACK 100h

.DATA
    appMode          DB  1                               ; 1 for game, 2 for chat, 3 for scoreboard if existed
    start_game_str   DB  'Start Game$'
    chat_str         DB  'Chat$'
    score_board_str  DB  'Score Board$'
    chat_demo_str    DB  'Chat Demo$'
    board_demo_str   DB  'Score Board Demo$'
    mode_label       DB  '=> $'
    waiting_str      DB  'Waiting for Players$'
    dots_str         DB  ".$", "..", "...", "....", 0

    padel_speed      equ 7
    padel_speed_2    equ 7
    ball_og_speed    equ 2
    ball_size        equ 3
    divide_factor    equ 2
    ball_og_speed_2  equ 2
    ball_size_2      equ 3
    divide_factor_2  equ 2

    inReset          db  0


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    gift_size        equ 6
    gift_speed       equ 10
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    

    inReset_2        db  0


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;Brick gifts



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    C6_freq          equ 3951
    D6_freq          equ 3520
    E6_freq          equ 3136
    F6_freq          equ 2794
    G6_freq          equ 2637
    A6_freq          equ 2349
    B6_freq          equ 2093
    C7_freq          equ 1976
    D7_freq          equ 1760
    E7_freq          equ 1568
    F7_freq          equ 1396
    G7_freq          equ 1318
    A7_freq          equ 1174
    B7_freq          equ 1046
    C8_freq          equ 987
    D8_freq          equ 880
    E8_freq          equ 784
    F8_freq          equ 740
    G8_freq          equ 698
    A8_freq          equ 659

    ; songNotes  dw F6_freq, E6_freq, D6_freq, C6_freq, D6_freq, E6_freq, G6_freq,
    ;             D6_freq, E6_freq, F6_freq, G6_freq, A6_freq, B6_freq, C7_freq,
    ;             B6_freq, A6_freq, G6_freq, F6_freq, E6_freq, D6_freq, C6_freq,
    ;             E6_freq, G6_freq, A6_freq, F6_freq, E6_freq, D6_freq, G6_freq,
    ;             A6_freq, G6_freq, B6_freq, C7_freq, E7_freq, D7_freq, G7_freq,
    ;             F6_freq, F7_freq, E7_freq, F6_freq, D6_freq, C6_freq, G6_freq,
    ;             A6_freq, D6_freq

    noteCount        equ 40
    noteTimer        dw  100                             ; Timer to control note playing

    freq             dw  0
    currentNotePos   dw  0                               ; Tracks the current position in the songNotes array

    timerForSwitch   dw  60
    ogTimerForSwitch equ 60
    seconds          db  4                               ;◄■■ VARIABLE IN DATA SEGMENT.



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
ClearScreen PROC FAR
                           mov         al, 0
                           mov         dx, 570
    Clear_outer:           
                           inc         dx
                           cmp         dx, 600
                           jz          end_Clear

                           mov         cx, 0
    Clear_inner:           
                           inc         cx
                           cmp         cx, 400
                           jz          Clear_outer

                           mov         ah, 0ch
                           int         10h
                           jmp         Clear_inner

    end_Clear:             
                           RET
ClearScreen ENDP

ClearScreen_2 PROC FAR
                           mov         al, 0
                           mov         dx, 550
    Clear_outer_2:         
                           inc         dx
                           cmp         dx, 600
                           jz          end_Clear_2

                           mov         cx, 400
    Clear_inner_2:         
                           inc         cx
                           cmp         cx, 800
                           jz          Clear_outer_2

                           mov         ah, 0ch
                           int         10h
                           jmp         Clear_inner_2

    end_Clear_2:           
                           RET
ClearScreen_2 ENDP

ResetAll PROC FAR
                           
                           mov         ball_x, 199
                           mov         ball_y, 560
                           mov         ball_dx, ball_og_speed
                           mov         ball_dy, ball_og_speed
                           mov         padel_x1, 174
                           mov         padel_x2, 224
                           mov         padel_y1, 581
                           mov         padel_y2, 590
                           mov         ball_dy, 2
                           mov         ball_dx, 0

                           mov         gift_color, 0
                           mov         bow_color, 0
                           mov         ribbon_color, 0
                           
                           push        bx
                           mov         bx, [current_gift_counter]
                           CALL        DrawGift
                           pop         bx

                           mov         [gift_ball_color],2
                           mov         [padel_width],40
                           mov         [padel_x] ,199
                           mov         [gift_timer],0
                           dec         display_lives
                           cmp         display_lives, 0
    ;    jle        GAMEOVERdd

                           

                           CALL        ClearScreen
                           cmp         selected_level, 1
                           jnz         cont1
                           CALL        DrawLevel1
                           jmp         cont
    cont1:                 
                           cmp         selected_level, 2
                           jnz         cont2
                           CALL        DrawLevel2
                           jmp         cont
    cont2:                 
                           cmp         selected_level, 3
                           CALL        DrawLevel3
    cont:                  
                           CALL        DrawPadel
                           mov         ball_color, 2
                           CALL        DrawBall
                           mov         bx,0
    ResetAllGifts:         
                           mov         byte ptr [gift_active+bx], 0
                           mov         gift_x, 0
                           mov         gift_y, 0
                           inc         bl
                           cmp         bx,[gift_count]
                           jne         ResetAllGifts
                           CALL        DrawPadel
                           
                           mov         inReset, 1
    GAMEOVER:              
                           RET
ResetAll ENDP

ResetAll_2 PROC FAR
                           mov         ball_x_2, 599
                           mov         ball_y_2, 560
                           mov         ball_dx_2, ball_og_speed_2
                           mov         ball_dy_2, ball_og_speed_2
                           mov         padel_x1_2, 574
                           mov         padel_x2_2, 624
                           mov         padel_y1_2, 581
                           mov         padel_y2_2, 590
                           mov         ball_dy_2, 2
                           mov         ball_dx_2, 0
                           dec         display_lives_2

                           CALL        ClearScreen_2
                           cmp         selected_level_2, 1
                           jnz         cont1_2
                           CALL        DrawLevel1_2
                           jmp         cont_2
    cont1_2:               
                           cmp         selected_level_2, 2
                           jnz         cont2_2
                           CALL        DrawLevel2_2
                           jmp         cont_2
    cont2_2:               
                           cmp         selected_level_2, 3
                           CALL        DrawLevel3_2
    cont_2:                
                           CALL        DrawPadel_2
                           mov         ball_color_2, 2
                           CALL        DrawBall_2
                           CALL        DrawPadel_2
                           mov         inReset_2, 1
                           RET
ResetAll_2 ENDP


MAIN PROC
                           MOV         AX, @DATA
                           MOV         DS, AX
    ; initinalize COM
    ;Set Divisor Latch Access Bit
                           mov         dx,3fbh                         ; Line Control Register
                           mov         al,10000000b                    ;Set Divisor Latch Access Bit
                           out         dx,al                           ;Out it
    ;Set LSB byte of the Baud Rate Divisor Latch register.
                           mov         dx,3f8h
                           mov         al,0ch
                           out         dx,al

    ;Set MSB byte of the Baud Rate Divisor Latch register.
                           mov         dx,3f9h
                           mov         al,00h
                           out         dx,al

    ;Set port configuration
                           mov         dx,3fbh
                           mov         al,00011011b
                           out         dx,al



                           mov         ah, 0
                           mov         al, 4h
                           int         10h
    main_menu:             
                           mov         ax, 0600h
                           mov         bh, 0
                           mov         cx, 0
                           mov         dx, 184Fh
                           int         10h
                           cmp         appMode, 1
                           jne         skip_start_game_label
                           mov         ah,2
                           mov         dx,0605h
                           int         10h
                           mov         ah, 9
                           mov         dx, offset mode_label
                           int         21h
    skip_start_game_label: 
                           mov         ah,2
                           mov         dx,0608h
                           int         10h
                           mov         ah, 9
                           mov         dx, offset start_game_str
                           int         21h

                           cmp         appMode, 2
                           jne         skip_chat_label
                           mov         ah,2
                           mov         dx,0A05h
                           int         10h
                           mov         ah, 9
                           mov         dx, offset mode_label
                           int         21h
    skip_chat_label:       
                           mov         ah,2
                           mov         dx,0A08h
                           int         10h
                           mov         ah, 9
                           mov         dx, offset chat_str
                           int         21h

                           cmp         appMode, 3
                           jne         skip_score_board_label
                           mov         ah,2
                           mov         dx,0E05h
                           int         10h
                           mov         ah, 9
                           mov         dx, offset mode_label
                           int         21h
    skip_score_board_label:
                           mov         ah,2
                           mov         dx,0E08h
                           int         10h
                           mov         ah, 9
                           mov         dx, offset score_board_str
                           int         21h

    skipInput:             
                           mov         ah,0
                           int         16h
                           cmp         ah, 50h                         ; Check if the pressed key is Down Arrow (Scan code 50h)
                           je          incAppMode
                           cmp         ah, 48h                         ; Check if the pressed key is Up Arrow (Scan code 48h)
                           je          decAppMode
                           cmp         al, 0Dh                         ; Check if the pressed key is Enter (ASCII 0Dh)
                           je          checkAppMode
                           jmp         skipInput

    incAppMode:            
                           cmp         appMode, 3
                           je          setAppModeToOne
                           inc         appMode
                           jmp         main_menu
    setAppModeToOne:       
                           mov         appMode, 1
                           jmp         main_menu

    decAppMode:            
                           cmp         appMode, 1
                           je          setAppModeToThree
                           dec         appMode
                           jmp         main_menu
    setAppModeToThree:     
                           mov         appMode, 3
                           jmp         main_menu

    checkAppMode:          
                           cmp         appMode, 1
                           je          callGame
                           cmp         appMode, 2
                           je          callChat
                           cmp         appMode, 3
                           je          callBoard
                           jmp         main_menu                       ; redundant

    callGame:              
                           call        WaitForPlayers
                           call        Game
                           jmp         main_menu

    callChat:              
                           call        CHAT
                           jmp         main_menu

    callBoard:             
                           call        SCORE_BOARD
                           jmp         main_menu

                           MOV         AX, 4C00h
                           INT         21h
MAIN ENDP

SCORE_BOARD PROC
                           mov         ax,0600h
                           mov         cx,0
                           mov         dx,184FH
                           int         10h
                           mov         ah, 2
                           mov         dx, 0
                           int         10h
                           mov         ah, 9
                           mov         dx, offset board_demo_str
                           int         21h
    continueBoard:         
                           mov         ah,0
                           int         16h
                           cmp         al, 1Bh                         ; Check if the pressed key is ESC (ASCII 1Bh)
                           jne         continueBoard
                           ret
SCORE_BOARD ENDP

CHAT PROC
                           mov         ax,0600h
                           mov         cx,0
                           mov         dx,184FH
                           int         10h
                           mov         ah, 2
                           mov         dx, 0
                           int         10h
                           mov         ah, 9
                           mov         dx, offset chat_demo_str
                           int         21h
    continueChat:          
                           mov         ah,0
                           int         16h
                           cmp         al, 1Bh                         ; Check if the pressed key is ESC (ASCII 1Bh)
                           jne         continueChat
                           ret
CHAT ENDP

GAME PROC

                           MOV         AX, 4F02h
                           MOV         BX, 103h
                           INT         10h

                           CALL        DrawLevel1
                           CALL        DrawLevel1_2

    ; CALL      DrawLevel2
    ; lea si, songNotes
    ; push si

    gameLoop:              

                           CMP         inReset, 1
                           JE          waitForReset1
                           Collision   selected_level
                           CALL        MovePadel
                           CALL        DrawPadel
                           MOV         ball_color, 0
                           CALL        DrawBall
                           ;CALL        MoveBall
                           MOV         BL, gift_ball_color
                           MOV         ball_color, BL
                           CALL        DrawBall
                           CALL        GiftLogic_1
                           JMP         skipPlayer1

    waitForReset1:         
                           mov         cx, 1000h
    waitloop:              
                           loop        waitloop

                           MOV         AH, 1
                           INT         16h
                           JNZ         resetPlayer1Done
                           JMP         skipPlayer1

    resetPlayer1Done:      
                           MOV         inReset, 0

    skipPlayer1:           


                           CMP         inReset_2, 1
                           JE          waitForReset2
                           Collision_2 selected_level_2
                           CALL        DrawPadel_2
                           CALL        MovePadel_2
                           MOV         ball_color_2, 0
                           CALL        DrawBall_2
                           ;CALL        MoveBall_2
    ;MOV         BL, gift_ball_color_2
                           MOV         ball_color_2, 2
                           JMP         skipPlayer2

    waitForReset2:         
                           mov         cx, 1000h
    waitloop_2:            
                           loop        waitloop_2
                           MOV         AH, 1
                           INT         16h
                           JNZ         resetPlayer2Done
                           JMP         skipPlayer2

    resetPlayer2Done:      
                           MOV         inReset_2, 0

    skipPlayer2:           
                           CALL        DrawBall_2


                           CALL        DisplayScore
                           CALL        DisplayLives
                           CALL        DisplayScore_2
                           CALL        DisplayLives_2
                           JMP         gameLoop                        ; Restart the song from the beginning
    ; :( too hard
                           ret
GAME ENDP


WaitForPlayers PROC
    startanimate:          
    ; Clear the screen
                           mov         ax, 0600h                       ; Function 06h: Scroll screen up
                           mov         bh, 0                           ; Background color (black)
                           mov         cx, 0                           ; Upper-left corner (row 0, column 0)
                           mov         dx, 184Fh                       ; Lower-right corner (row 24, column 79)
                           int         10h                             ; Call BIOS interrupt to clear the screen

    ; Display "Waiting for Players" at a specific position
                           mov         ah, 2                           ; Function 02h: Set cursor position
                           mov         dh, 0Ah                         ; Row position (change this to move vertically)
                           mov         dl, 8h                          ; Column position (change this to move horizontally)
                           int         10h                             ; Call BIOS interrupt to position the cursor

                           mov         ah, 9                           ; Function 09h: Display string
                           mov         dx, offset waiting_str          ; Offset of the string to display
                           int         21h
                           mov         bx,0
    delay_loop:            
                           CALL        delay
    
                           mov         ah, 9                           ; Function 09h: Display string
                           mov         dx, offset dots_str             ; Offset of the string to display
                           int         21h
                           inc         bx
                           cmp         bx,5
                           jl          delay_loop
                           jmp         startanimate
                           ret
WaitForPlayers ENDP



delay proc
    delaying:              
                           in          al, dx
                           and         al, 00100000b
                           jz          noKey

                           mov         dx, 3F8h
                           mov         al, 1
                           out         dx, al
    noKey:                 
                           mov         dx, 3FDh
                           in          al, dx
                           and         al, 1
                           jz          noRecievedData

                           mov         dx, 3F8h
                           in          al, dx
                           cmp         al,1
                           jnz         noRecievedData
                           
                    
                           CALL        GAME
    noRecievedData:        
                           mov         ah, 2ch
                           int         21h

                           cmp         dh, seconds
                           je          delaying
                           mov         seconds, dh
                           ret
delay endp

beep proc FAR
                           push        ax
                           push        bx
                           push        cx
                           push        dx

                           mov         al, 182                         ; Prepare the speaker for the
                           out         43h, al                         ;  note.
                           mov         ax, 400                         ; Frequency number (in decimal)
    ;  for middle C.
                           out         42h, al                         ; Output low byte.
                           mov         al, ah                          ; Output high byte.
                           out         42h, al
                           in          al, 61h                         ; Turn on note (get value from
    ;  port 61h).
                           or          al, 00000011b                   ; Set bits 1 and 0.
                           out         61h, al                         ; Send new value.
                           mov         bx, 2                           ; Pause for duration of note.
.pause1:
                           mov         cx, 65535
.pause2:
                           dec         cx
                           jne         .pause2
                           dec         bx
                           jne         .pause1
                           in          al, 61h                         ; Turn off note (get value from
    ;  port 61h).
                           and         al, 11111100b                   ; Reset bits 1 and 0.
                           out         61h, al                         ; Send new value.

                           pop         dx
                           pop         cx
                           pop         bx
                           pop         ax

                           ret
beep endp
    ;description

GiftLogic_1 PROC
                           mov         bx, [current_gift_counter]
                           mov         cx, gift_count
                           cmp         bx, cx
                           jl          reset
                           xor         bx,bx
    reset:                 
                           CALL        MoveGift
                           mov         al,[gift_colors_list+bx]
                           mov         gift_color, al
                           mov         al,[gift_ribbon_list+bx]
                           mov         bow_color, al
                           mov         ribbon_color, al

                           CALL        DrawGift
                       

                           inc         bx
                           mov         [current_gift_counter], bx
                           cmp         gift_ball_color, 2
                           je          wait_30

                           inc         [gift_timer]
                           mov         ax, [gift_timer]
                           cmp         ax, 10000
                           jb          wait_30
                           mov         gift_ball_color, 2
                           mov         [padel_width],40

                           mov         gift_timer, 0
                        
    wait_30:               


                           ret
GiftLogic_1 ENDP

END MAIN
