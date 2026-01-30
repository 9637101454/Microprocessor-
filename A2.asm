Section .data
m2 db 10,10,'Enter the string'
m2_len equ $-m2
m3 db 'Lenght of the string'
m3_len equ $-m3

Section .bss
srcstr resb 20
count resb 1
dispbuff resb 2

%macro disp 2
   mov rax,4
   mov rbx,1
   mov rcx,%1
   mov rdx,%2
   int 80h
   %endmacro
   
   %macro acceptstr 1
      mov rax,03
      mov rbx,0
      mov rcx,%1
      int 80h
      %endmacro

Section .text
    global _start
    
_start:
   disp m2,m2_len
   acceptstr srcstr
   dec al
   mov [count], al
   disp m3,m3_len
   mov bl,[count]
   call display
   mov rax,01
   int 80h
   
   display:
     mov cl,2
     mov rdi, dispbuff
     
     d1:
     rol bl,4
     mov al,bl
     and al,0Fh
     cmp al,09
     jbe d2
     add al,07
     
     d2:
     add al,30h
     mov[rdi],al
     inc rdi
     dec cl
     jnz d1
     disp dispbuff,2
     ret