;// Premier programme: afficher hello world en assembleur

section .data
;.data: section correspondant aux définitions des données avec valeurs
;.bss: section correspondant aux réservations d'espaces mémoires
;.text: section pour l'ecriture du code du programme

welcome_msg db "Welcome to low level world",0
;ecriture caractère par caractère en mémoire
;db: reservation de 1 byte (8bits)
;dw: reservation de 2 bytes (16bits)
;dd: reservation de 4 bytes (32bits)
;dq: reservation de 8 bytes (64bits)

len_msg equ $ - welcome_msg
;definition de la longueur à partir de l'adresse du msg jusqu'à la position actuelle '$'

section .text
;//Indication au linker
global _start
_start:

;//Affichage
mov rax,1
;sys_write(), avec paramètres fd, buffer, size
mov rdi,1
;fd: terminal
lea rsi, [rel welcome_msg]
;on peut écrire mov rsi,msg
;mais il est préférable d' utilser un lea
mov rdx,len_msg
syscall

;sortie système
mov rax,60
;sys_exit()
xor rdi,rdi
;remise à zeo de rdi
syscall