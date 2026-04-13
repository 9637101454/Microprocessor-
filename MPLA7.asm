section .data
    msg1 db "Enter 4-digit Hex Number: ", 0
    len1 equ $-msg1
    msg2 db 10, "Equivalent BCD Number: ", 0
    len2 equ $-msg2
    newline db 10

section .bss
    num resb 17        
    bcd resb 10        
    
%macro scall 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .text
    global _start

_start:
    ; Display message
    scall 1, 1, msg1, len1
    ; Accept 4-digit hex number
    scall 0, 0, num, 5 
    
    ; Convert ASCII Hex to Actual Hex in RBX
    call ascii_to_hex
    
    ; Convert Hex to BCD
    mov rax, rbx       
    mov rbx, 10       
    mov rdi, bcd       
    
    ; Division loop for BCD
    mov rcx, 0       
loop_bcd:
    mov rdx, 0
    div rbx            
    push rdx           
    inc rcx
    cmp rax, 0
    jne loop_bcd

   
display_bcd:
    pop rdx
    add dl, 30h       
    mov [rdi], dl
    inc rdi
    loop display_bcd

   
    scall 1, 1, msg2, len2
    scall 1, 1, bcd, 5 ; Print BCD
    
 
    mov rax, 60
    xor rdi, rdi
    syscall

ascii_to_hex:
    mov rsi, num
    mov rbx, 0
    mov rcx, 4
loop_hex:
    rol rbx, 4
    mov al, [rsi]
    cmp al, 39h
    jbe skip
    sub al, 07h
skip:
    sub al, 30h
    add bl, al
    inc rsi
    loop loop_hex
    ret
