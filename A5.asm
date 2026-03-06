;X86/64 ALP for 4-digit HEX to BCD conversion
section .data
    msg1 db "Enter 4-digit Hex Number: ", 0
    len1 equ $-msg1
    msg2 db 10, "Equivalent BCD Number: ", 0
    len2 equ $-msg2
    newline db 10

section .bss
    num resb 17        ; To store input hex (e.g., FFFF)
    bcd resb 10        ; To store BCD result
    
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
    mov rax, rbx       ; Move hex number to RAX for division
    mov rbx, 10        ; Divisor
    mov rdi, bcd       ; Result pointer
    
    ; Division loop for BCD
    mov rcx, 0         ; Counter
loop_bcd:
    mov rdx, 0
    div rbx            ; RAX/10 -> RAX=Quotient, RDX=Remainder
    push rdx           ; Store remainder (digits in reverse)
    inc rcx
    cmp rax, 0
    jne loop_bcd

    ; Pop remainders and convert to ASCII
display_bcd:
    pop rdx
    add dl, 30h        ; Convert to ASCII
    mov [rdi], dl
    inc rdi
    loop display_bcd

    ; Print Result
    scall 1, 1, msg2, len2
    scall 1, 1, bcd, 5 ; Print BCD
    
    ; Exit
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
