Section .data
msg1 db 10,13,"Enter 5 64 bit numbers"
len1 equ $ -msg1
msg2 db 10,13,"Enter 5 64 bit numbers"
len2 equ $ -msg2

Section .bss
  array resd 200
  counter resb 1
  
Section .text
       global _start
       
_start:
      ;Display
     mov Rax,1
     mov Rdi,1
     mov Rsi,msg1
     mov Rdx,len1
     syscall
     
     ;accept
     mov byte[counter],05
     mov ebx,00
          loop1:
             mov eax,0
             mov edi,0
             mov esi,array
             add esi,ebx
             mov edx,17
             syscall
             add ebx,17
             dec byte[counter]
             JNZ loop1
             
     ;Display
     mov Rax,1
     mov Rdi,1
     mov Rsi,msg2
     mov Rdx,len2
     syscall
     mov byte[counter],05
     mov ebx,00
          loop2:
             mov eax,1
             mov edi,1
             mov esi,array
             add esi,ebx
             mov edx,17
             syscall
             add ebx,17
             dec byte[counter]
             JNZ loop2
             
     ;exit system call 
     mov eax,60
     mov edi,0
     syscall