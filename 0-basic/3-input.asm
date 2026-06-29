;// Saisir une valeur au clavier et afficher

section .data
msg_input db "Veuillez appuyer sur une touche ...", 10
msg_input_len equ $ - msg_input
msg db "Le caractère saisi est: ",0
msg_len equ $ - msg

section .bss
;.bss: section correspondant aux réservations d'espaces mémoires
buffer resb 2

section .text
global _start
_start:

;//Message avant saisie
mov rax,1
mov rdi,1
lea rsi, [rel msg_input]
mov rdx, msg_input_len
syscall

;//Saisie
mov rax,0
;0: sys_read(), avec paramètres fd, buffer, size
mov rdi,0
;0: clavier
lea rsi, [rel buffer]
mov rdx, 2
syscall


;//Affichage de message
mov rax,1
mov rdi,1
lea rsi, [rel msg]
mov rdx, msg_len
syscall

;//Affichage du caractère
mov rax,1
mov rdi,1
lea rsi, [rel buffer]
mov rdx, 2
syscall

;//Sortie système
mov rax,60
xor rdi,rdi
syscall