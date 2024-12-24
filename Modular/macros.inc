
Collision macro lvl
              LOCAL coll1
              LOCAL coll2
              LOCAL coll3
              LOCAL coll_end
              cmp   lvl, 1
              je    coll1
              cmp   lvl, 2
              je    coll2
              cmp   lvl, 3
              je    coll3
    coll1:    
              call  Collision1
              jmp   coll_end
    coll2:    
              call  Collision2
              jmp   coll_end
    coll3:    
              call  Collision3
    coll_end: 
endm

Collision_2 macro lvl_2
                LOCAL coll1_2
                LOCAL coll2_2
                LOCAL coll3_2
                LOCAL coll_end_2
                cmp   lvl_2, 1
                je    coll1_2
                cmp   lvl_2, 2
                je    coll2_2
                cmp   lvl_2, 3
                je    coll3_2
    coll1_2:    
                call  Collision1_2
                jmp   coll_end_2
    coll2_2:    
                call  Collision2_2
                jmp   coll_end_2
    coll3_2:    
                call  Collision3_2
    coll_end_2: 
endm

clearscreen_textMode macro 
            push ax
            push bx
            push cx
            push dx
           
            mov ax,0600h
            mov cx,0
            mov dx,184fh
            int 10h
            
            pop dx
            pop cx
            pop bx
            pop ax
endm

DisplayUsers macro player1, player2
            push ax
            push bx
            push cx
            push dx
           
           ; Update cursor position
            mov ah, 2
            mov dh, 5
            mov dl, 30
            int 10h 

            mov ah, 9
            lea dx, player1      ;prints player 1 string
            int 21h  

            ; Update cursor position
            mov ah, 2
            mov dh, 12
            mov dl, 30
            int 10h  

            mov ah, 9
            lea dx, player2      ;prints player 2 string
            int 21h 

            pop dx
            pop cx
            pop bx
            pop ax
endm
