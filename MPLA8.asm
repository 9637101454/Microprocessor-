section .data
    msg1 db "Enter 5-digit BCD Number: ", 0
    len1 equ $-msg1
    msg2 db 10, "Equivalent HEX Number: ", 0
    len2 equ $-msg2
    newline db 10
    
section .bss
    bcd_input resb 6       
    hex_output resb 8      

section .text
    global _start

_start:
    
    mov rax, 1             
    mov rdi, 1             
    mov rsi, msg1      
    mov rdx, len1       
    syscall

    
    mov rax, 0            
    mov rdi, 0             
    mov rsi, bcd_input     
    mov rdx, 6             
    syscall

   
    mov rsi, bcd_input     
    mov rcx, 5            
    xor rax, rax           
    mov rbx, 10           

convert_loop:
    mul rbx                
    
    xor r8, r8             
    mov r8b, byte [rsi]    
    sub r8b, 30h          
    
    add rax, r8            
    inc rsi                
    loop convert_loop      

    
    mov r9, rax            
                           
    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, len2
    syscall

   
    mov rbx, r9            
    mov rcx, 8             
    mov rdi, hex_output   

hex_to_ascii_loop:
    rol ebx, 4             
    mov al, bl             
    and al, 0x0F           
    
    cmp al, 09h            
    jbe add_30h
    add al, 07h            

add_30h:
    add al, 30h            
    mov [rdi], al          
    inc rdi               
    loop hex_to_ascii_loop 

   
    mov rax, 1            
    mov rdi, 1             
    mov rsi, hex_output    
    mov rdx, 8             
    syscall

    
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    
    mov rax, 60            ; sys_exit
    xor rdi, rdi           ; exit code 0
    syscall