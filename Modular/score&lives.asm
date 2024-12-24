PUBLIC DisplayScore, DisplayLives, DisplayScore_2, DisplayLives_2
public score, display_score, score_2, display_score_2
public display_lives, display_lives_2
.MODEL small
.STACK 100h

.DATA

score            dw  0
display_score    dw  0
score_str        db  'Score: $'
lives_str        db  'Lives: $'
display_lives    db  5
score_2          dw  0
display_score_2  dw  0
display_lives_2  db  5                                                                                      ; 4 * 7 + 7 * 12 + 10 * 21


.CODE

DisplayScore proc FAR
                           push        ax
                           push        bx
                           push        cx
                           push        dx

                           mov         ah, 2
                           mov         dx, 0B0Ah
                           int         10h

                           mov         ah,9
                           mov         dx, offset score_str
                           int         21h

                           xor         cx,cx
                           mov         ax, display_score
                           mov         bx,10
    divLoop:               
                           xor         dx,dx
                           div         bx
                           push        dx
                           inc         cx
                           cmp         ax,0
                           ja          divLoop

                           mov         ah, 0Eh
    printLoop:             
                           pop         dx
                           mov         al,dl
                           or          al,'0'
                           int         10h
                           loop        printLoop

                           pop         dx
                           pop         cx
                           pop         bx
                           pop         ax
                           ret
DisplayScore endp

DisplayLives proc FAR
                           push        ax
                           push        bx
                           push        dx
                           mov         ah, 2
                           mov         dx, 0B1Fh
                           int         10h

                           mov         ah, 9
                           mov         dx, offset lives_str
                           int         21h

                           mov         bl, 04h
                           mov         ah, 0Eh
                           mov         al, display_lives
                           or          al, '0'
                           int         10h
                           pop         dx
                           pop         bx
                           pop         ax
                           ret
DisplayLives endp

DisplayScore_2 proc FAR
                           push        ax
                           push        bx
                           push        cx
                           push        dx

                           mov         ah, 2
                           mov         dx, 0B3Ch
                           int         10h

                           mov         ah,9
                           mov         dx, offset score_str
                           int         21h

                           xor         cx,cx
                           mov         ax, display_score_2
                           mov         bx,10
    divLoop_2:             
                           xor         dx,dx
                           div         bx
                           push        dx
                           inc         cx
                           cmp         ax,0
                           ja          divLoop_2

                           mov         ah, 0Eh
    printLoop_2:           
                           pop         dx
                           mov         al,dl
                           or          al,'0'
                           int         10h
                           loop        printLoop_2

                           pop         dx
                           pop         cx
                           pop         bx
                           pop         ax
                           ret
DisplayScore_2 endp

DisplayLives_2 proc FAR
                           push        ax
                           push        bx
                           push        dx
                           mov         ah, 2
                           mov         dx, 0B51h
                           int         10h

                           mov         ah, 9
                           mov         dx, offset lives_str
                           int         21h
                           mov         bl, 04h
                           mov         ah, 0Eh
                           mov         al, display_lives_2
                           or          al, '0'
                           int         10h
                           pop         dx
                           pop         bx
                           pop         ax
                           ret
DisplayLives_2 endp


ret

END    