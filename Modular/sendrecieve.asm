    PUBLIC Send, Receive
    PUBLIC sendv
    PUBLIC recievev
    
 

.MODEL small
.STACK 100h

.DATA
    sendv    db ?
    recievev db ?

.CODE

Send PROC FAR
                      in   al, dx
                      and  al, 00100000b
                      jz   skipS

                      mov  dx, 3F8h
                      mov  al, sendv
                      out  dx, al
    skipS:
            ret
Send ENDP 


Receive PROC FAR
                      mov  dx, 3FDh
                      in   al, dx
                      and  al, 1
                      jz   skipR

                      mov  dx, 3F8h
                      in   ax, dx
                      mov recievev, al
    skipR:
                      ret
Receive ENDP

ret 
END