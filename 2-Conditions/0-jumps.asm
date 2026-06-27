;//Conditions simples

section .data
intro db "-------- Comparaison de 2 nombres --------",10
len_intro equ $ - intro

msg1 db "Veullez saisir le premier nombre à comparer",10
len_msg1 equ $ - msg1

msg2 db "Veullez saisir le second nombre:",10
len_msg2 equ $ - msg2


output0 db "Les deux nombres sont équivalents:",10
len_out0 equ $ - output0

output1 db "Le premier nombre est plus petit",10
len_out1 equ $ - output1

output2 db "Le premier nombre est plus grand",10
len_out2 equ $ - output2

section .bss
input1 resb 16
input2 resb 16

section .text
global _start
_start:

;//Affichage mesg d' intro
mov rax,1
mov rdi,1
lea rsi, [rel intro]
mov rdx,len_intro
syscall

;//Mesg of first input
mov rax,1
mov rdi,1
lea rsi, [rel msg1]
mov rdx,len_msg1
syscall

;//First input
mov rax,0
mov rdi,0
lea rsi, [rel input1]
mov rdx, 16
syscall

;//Mesg of second input
mov rax,1
mov rdi,1
lea rsi, [rel msg2]
mov rdx,len_msg2
syscall

;//Second input
mov rax,0
mov rdi,0
lea rsi, [rel input2]
mov rdx, 16
syscall

lea rsi, [rel input1]
call parse_int
mov r12d, eax

lea rsi, [rel input2]
call parse_int
mov r13d, eax

;//Comparaison
cmp r12d, r13d
je .equality
jl .lower
jg .greater

.equality:
    mov rax,1
    mov rdi,1
    lea rsi, [rel output0]
    mov rdx, len_out0
    syscall
    jmp .exit

.lower:
    mov rax,1
    mov rdi,1
    lea rsi, [rel output1]
    mov rdx, len_out1
    syscall
    jmp .exit

.greater:
    mov rax,1
    mov rdi,1
    lea rsi, [rel output2]
    mov rdx, len_out2
    syscall
    jmp .exit

;//sortie système
.exit:
mov rax,60
xor rdi,rdi
syscall

; parse_int : rsi = buffer ASCII → eax = entier signé 32 bits
parse_int:
    xor eax, eax
    xor ecx, ecx
    movzx edx, byte [rsi]
    cmp dl, '-'
    jne .digits
    mov ecx, 1
    inc rsi
.digits:
    movzx edx, byte [rsi]
    cmp dl, '0'
    jl .done
    cmp dl, '9'
    jg .done
    sub dl, '0'
    imul eax, eax, 10
    add eax, edx
    inc rsi
    jmp .digits
.done:
    test ecx, ecx
    jz .pos
    neg eax
.pos:
    ret