    PUBLIC Send, Receive
    PUBLIC sendv
    PUBLIC recievev
    EXTRN MovePadel_2:FAR
    EXTRN sendDelay:FAR
    
    EXTRN ball_x_2:WORD
    EXTRN ball_y_2:WORD
    EXTRN DrawBall_2:FAR
    EXTRN MoveBall_2:FAR
    EXTRN ball_color_2:BYTE
    
 

.MODEL small
.STACK 100h

.DATA
    sendv    db ?
    recievev db ?

.CODE

Send PROC FAR
              waitSend:
                 in   al, dx
                 and  al, 00100000b
                 jz   skipS

                 mov  dx, 3F8h
                 mov  al, sendv
                 out  dx, al
    skipS:       
                 ret
Send ENDP

; Receive PROC FAR
;            waitRecieve:
;                  mov  dx, 3FDh
;                  in   al, dx
;                  and  al, 1
;                  jz   skipR

;                  mov  dx, 3F8h
;                  in   ax, dx
;                  mov  recievev, al
;                  ret
;     skipR:       
;                  ret
; Receive ENDP



Receive PROC FAR
                 mov  dx, 3FDh
                 in   al, dx
                 and  al, 1
                 jz   skipR

                 mov  dx, 3F8h
                 in   ax, dx
                 mov  recievev, al
                 mov  cl,6
                 shr  al, cl
                ; Mask the last two bits
                and  al, 00000011b
                cmp  al, 2
                jz   receivePadel
                cmp  al, 1
                jz   receiveBallx
                cmp  al, 3
                jz   receiveBally
                ret
                    
                      
                  
    receivePadel: 
                 mov cl,2
                 mov al,[recievev]
                 and al,00111111b
                 mov [recievev],al
                 CALL MovePadel_2
                 jmp  skipR

    receiveBallx:
                 ;CALL sendDelay
                
                 mov  ball_color_2, 0
                 call DrawBall_2

                 mov  bL, recievev
                 and  bL, 00111111b
                 mov  cl,3
                 shl  bx, cl
                 add  bx, 400

                 mov  ball_x_2, bx

                 ;CALL MoveBall_2
                 jmp  skipR

    receiveBally:
                 ;CALL sendDelay

                 mov  ball_color_2, 0
                 call DrawBall_2

                 mov  bL, recievev
                 and  bL, 00111111b
                 mov  cl,3
                 shl  bx, cl    
                 add  bx,200

                 mov  ball_y_2, bx

                 ;CALL MoveBall_2
                 jmp  skipR


    skipR:       
                 ret
Receive ENDP

                 ret
END