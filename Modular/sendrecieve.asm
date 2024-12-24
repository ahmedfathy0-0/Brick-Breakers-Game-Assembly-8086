    PUBLIC Send, Receive
    PUBLIC sendv
    PUBLIC recievev
    
 

.MODEL small
.STACK 100h

.DATA
    sendv    dw ?
    recievev dw ?

.CODE

Send PROC FAR
                      in   al, dx
                      and  al, 00100000b
                      jz   skipS

                      mov  dx, 3F8h
                      mov  ax, sendv
                      out  dx, ax
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
                      mov recievev, ax
    skipR:
                      ret
Receive ENDP

ret 
END