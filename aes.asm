org 100h

    

.data 
array db 032h,088h,031h,0e0h,043h,05ah,031h,037h,0f6h,030h,098h,07h,0a8h,08dh,0a2h,034h

table    db 63h,7ch,77h,7bh,0f2h,6bh,6fh,0c5h,30h,01h,67h,2bh,0feh,0d7h,0abh,76h 
       db 0cah,82h,0c9h,7dh,0fah,59h,47h,0f0h,0adh,0d4h,0a2h,0afh,9ch,0a4h,72h,0c0h 
         db 0b7h,0fdh,93h,26h,36h,3fh,0f7h,0cch,34h,0a5h,0e5h,0f1h,71h,0d8h,31h,15h
       db 04h,0c7h,23h,0c3h,18h,96h,05h,9ah,07h,12h,80h,0e2h,0ebh,27h,0b2h,75h 
       db 09h,83h,2ch,1ah,1bh,6eh,5ah,0a0h,52h,3bh,0d6h,0b3h,29h,0e3h,2fh,84h 
       db 53h,0d1h,00h,0edh,20h,0fch,0b1h,5bh,6ah,0cbh,0beh,39h,4ah,4ch,58h,0cfh 
       db 0d0h,0efh,0aah,0fbh,43h,4dh,33h,85h,45h,0f9h,02h,7fh,50h,3ch,9fh,0a8h 
       db 51h,0a3h,40h,8fh,92h,9dh,38h,0f5h,0bch,0b6h,0dah,21h,10h,0ffh,0f3h,0d2h 
       db 0cdh,0ch,13h,0ech,5fh,97h,44h,17h,0c4h,0a7h,7eh,3dh,64h,5dh,19h,73h 
       db 60h,81h,4fh,0dch,22h,2ah,90h,88h,46h,0eeh,0b8h,14h,0deh,5eh,0bh,0dbh 
       db 0e0h,32h,3ah,0ah,49h,06h,24h,5ch,0c2h,0d3h,0ach,62h,91h,95h,0e4h,79h 
        db 0e7h,0c8h,37h,6dh,8dh,0d5h,4eh,0a9h,6ch,56h,0f4h,0eah,65h,7ah,0aeh,08h 
       db 0bah,78h,25h,2eh,1ch,0a6h,0b4h,0c6h,0e8h,0ddh,74h,1fh,4bh,0bdh,8bh,8ah 
       db 70h,3eh,0b5h,66h,48h,03h,0f6h,0eh,61h,35h,57h,0b9h,86h,0c1h,1dh,9eh 
       db 0e1h,0f8h,98h,11h,69h,0d9h,8eh,94h,9bh,1eh,87h,0e9h,0ceh,55h,28h,0dfh 
       db 8ch,0a1h,89h,0dh,0bfh,0e6h,42h,68h,41h,99h,2dh,0fh,0b0h,54h,0bbh,16h   
array2 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
four db 4
x dw 0h
key db 02bh,028h,0abh,009h,07eh,0aeh,0f7h,0cfh,015h,0d2h,015h,04fh,016h,0a6h,088h,03ch 
tmp db 00h,00h,00h,00h
curr dw 00h
Rcon        db 01h,02h,04h,08h,010h,020h,040h,080h,01bh,036h 
sbox db 02h,03h,01h,01h,01h,02h,03h,01h,01h,01h,02h,03h,03h,01h,01h,02h
rows dw 0
errmsg db "please enter valid hex number$"
promptmsg db "please enter valid 16 hex number to be encrypted:$" 
str db 'Iteration $'
tenn db '10$'
               
.code
    call read
    call addroundkey
    
     mov di,1
    mov  cx,9
    
LLoop:      push cx
            push di
            call subbytes
          call shiftrows
          call mixcolumns 
          call keyschedule
          call addroundkey 
          pop di
          call output
          pop cx 
          loop LLoop
    push di
    call keyschedule
    call subbytes
    call shiftrows
    call addroundkey 
    pop di
    call output

    
ret       

keySchedule PROC   near
                          
        xor     ax,ax 
        xor     si,si
        xor     cx,cx
        xor     bx,bx
        xor     dx,dx  
        xor     di,di
                          
        mov     al,Key[3] 
        mov     si,ax
        mov     al,table[si]  
        mov     tmp[3],al  
        
        mov     al,Key[7] 
        mov     si,ax
        mov     al,table[si]  
        mov     tmp[0],al 
        
        mov     al,Key[11] 
        mov     si,ax
        mov     al,table[si]  
        mov     tmp[1],al 
        
        mov     al,Key[15] 
        mov     si,ax
        mov     al,table[si]  
        mov     tmp[2],al
        
        mov     cx,0 
        mov     si,0
        
Loop1:  
        push    si 
        mov     si,cx
        mov     al,tmp[si]
        pop     si
        mov     ah,key[si]
        xor     al,ah
        cmp     si,04h
        jnb     blbizo            
        push    si
        add     si,curr   
        mov     ah,Rcon[si] 
        xor     al,ah
        pop     si
blbizo: mov     key[si],al
        add     si,4 
        inc     cx
        cmp     cx,4
        jnz     Loop1 
        
        mov     cx,1
        
        
Loop2:  mov     si,cx

        mov     dx,0  
        
Loop3:  dec     si
        mov     al,key[si]
        inc     si
        mov     ah,key[si]
        xor     al,ah
        mov     key[si],al
        
        add     si,4
         
        inc     dx
        
        cmp     dx,04h
        
        jnz     Loop3
        
        inc     cx
        
        cmp     cx,4
        jnz     Loop2 
        
        inc curr  
        
       
       
                         
ret    
keySchedule    ENDP
    
    


print proc near
    mov al,array[si]
    mov cx,0
L2: cmp ax,0
    jz print1 
    mov bx,10
    div bx
    push dx
    inc cx
    xor dx,dx
    jmp L2
print1:pop dx 
       add dx,48
       mov ah,2
       int 21h
       loop print1
ret
print endp 
addroundkey proc near 
     xor     ax,ax 
        xor     si,si
        xor     cx,cx
        xor     bx,bx
        xor     dx,dx  
        xor     di,di
    mov si,0
    mov cx,16
Gad:mov bl,key[si]
    mov al,array[si]
    xor array[si],bl
    inc si
    loop Gad
ret
addroundkey endp    
    
shiftrows proc near 
     xor     ax,ax 
        xor     si,si
        xor     cx,cx
        xor     bx,bx
        xor     dx,dx  
        xor     di,di 
        mov     x,ax
    mov si,0
    mov cx, 16
L3: mov al,array[si]
    mov array2[si],al 
    inc si
    loop L3
    xor si,si
    mov cx,4
    mov di,4
    
L4: mov dx,x
L6: cmp dx,0
    jz L5
    mov bx,si
    sub bx,x
    add bx,4
    mov al,array2[si]
    mov array[bx],al
    inc si
    dec di
    dec dx
    jmp L6
L5: mov bx,si
    sub bx,x
    mov al,array2[si]
    mov array[bx],al
    inc si
    dec di             
    jnz L5
    inc x
    mov di,4
    loop L4
    ret 
shiftrows endp    
        
subbytes proc near
     xor     ax,ax 
        xor     si,si
        xor     cx,cx
        xor     bx,bx
        xor     dx,dx  
        xor     di,di
     push cx
     xor bx,bx
     mov si,0
     mov cx,16
L1:  mov bl,array[si] 
     mov bl,table[bx]
     mov array[si],bl
     inc si
     loop L1
     pop cx
     ret 
subbytes endp
;
; 
;	
;
mixColumns proc near
        xor     ax,ax 
        xor     si,si
        xor     cx,cx
        xor     bx,bx
        xor     dx,dx  
        xor     di,di 
        mov rows,ax
Mosloop1:   
        mov al,array[bx+si]
        mov ah,sbox[di]
        cmp ah,01h
        jz Moscase1
        cmp ah,02h
        jz Moscase2
    
Moscase3:
        xor dl,al
        test al,80h
        jz MoscaseShiftOnly
    
MoscaseXor1:
        shl al,1
        xor al,1bh
        xor dl,al
        jmp Mosendloop
MoscaseShiftOnly1:
        shl al,1
        xor dl,al
        jmp Mosendloop
    
Moscase1:
        xor dl,al
        jmp Mosendloop
    
Moscase2:
        test al,80h
        jz MoscaseShiftOnly
MoscaseXor:
        shl al,1
        xor al,1bh
        xor dl,al
        jmp Mosendloop
MoscaseShiftOnly:
        shl al,1
        xor dl,al
Mosendloop:
        inc di
        add bx,4
        cmp bx,16   
        jnz Mosloop1 
        mov bx,rows
        mov array2[bx+si],dl  
        mov dl,0
        mov bx,0
        inc si
        mov di,rows
        cmp si,4   
        jnz Mosloop1  
        mov si,0
        add rows,4 
        mov di,rows
        cmp rows,16
        jnz Mosloop1
            
        mov si,0    
returntoarr:
        mov al,array2[si]
        mov array[si],al
        inc si
        cmp si,16
        jnz returntoarr
            
          
    ret 

mixColumns endp 

	
read proc near
    startread:   
             xor di,di
             xor si,si
             mov ah,09h
             lea dx,promptmsg 
             int 21h
             mov ah,2
             mov dl,0ah
             int 21h
             mov dl,0dh
             int 21h
    loop1read:   mov cx,2
    loop2read:   mov ah,01h
             int 21h 
             cmp al,'0'
             jl errprint
             cmp al,'9'
             jle intin
             cmp al,'A'
             jl errprint
             cmp al,'F'
             jle hexin2
             cmp al,'a'
             jl errprint
             cmp al,'f'
             jle hexin
             jmp errprint
             
    
    intin:   sub al,'0'
             cmp cx,2
             jnz normal
             jmp shiftadd
    
    hexin:   add al,10
             sub al,'a'
             cmp cx,2
             jnz normal
             jmp shiftadd      
    
    hexin2:  sub al,'A'
             add al,10
             cmp cx,2
             jnz normal
             jmp shiftadd
             
    
    normal:  add bl,al
             jmp endloop1read
    
    shiftadd:shl al,4
             add bl,al
             jmp endloop2read
      
    endloop2read:loop loop2read
    endloop1read:mov array[si],bl
             xor bl,bl
             inc si
             cmp si,16
             jnz loop1read
             mov ah,2
             mov dl,0ah
             int 21h
             mov dl,0dh
             int 21h
             mov dl,0ah
             int 21h
             mov dl,0dh
             int 21h
             jmp endprocread
    
    errprint:mov ah,2
             mov dl,0ah
             int 21h
             mov dl,0dh
             int 21h
             mov ah,09h
             lea dx,errmsg 
             int 21h
             mov ah,2
             mov dl,0ah
             int 21h
             mov dl,0dh
             int 21h
             jmp loop2read       
    
    endprocread: ret        
    read endp 

output proc near
    lea dx,str
    mov ah,09h
    int 21h
    cmp di,0ah
    jz ten
    mov dx,di
    add dl,30h
    mov ah,02h
    int 21h
    jmp nextline
ten:lea dx,tenn
    mov ah,09h
    int 21h
nextline:
    mov dl,0dh
    mov ah,02h
    int 21h
    mov dl,0ah
    mov ah,02h
    int 21h
    xor si,si
    mov cx,16
    mov bl,0
az: mov dl,array[si]
    rol dl,4
    and dl,0fh
    cmp dl,0ah
    jge charachter
    add dl,30h
    jmp endfirst
charachter:
    add dl,37h
endfirst: 
    mov ah,02h
    int 21h           
    mov dl,array[si]
    and dl,0fh
    cmp dl,0ah
    jge charachter2
    add dl,30h
    jmp endsecond
charachter2:
    add dl,37h
endsecond:
    mov ah,02h
    int 21h 
    mov dl,20h        
    mov ah,02h
    int 21h
    inc bl
    cmp bl,4
    js az2
    xor bl,bl
    mov dl,0ah
    mov ah,02h
    int 21h
    mov dl,0dh
    mov ah,02h
    int 21h 
az2:inc si
    loop az
    mov dl,0ah
    mov ah,02h
    int 21h
    inc di
    
ret 
output endp
    