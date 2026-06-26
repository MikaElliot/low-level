;// PROGRAMME ASSEMBLEUR QUI DÉVINE VOTRE AGE

section .data
;//Données utiles pour les sorties
msg1 db "Veullez saisir votre age: ",0
len1 equ $ - msg1
msg2 db "Votre age est: ",10
len2 equ $ - msg2

section .bss
;//Données utilse pour les entrées
age resb 4

section .text
global _start
_start:

;//Affichage du message 1
mov rax,1
mov rdi,1
lea rsi, [rel msg1]
mov rdx,len1
syscall

mov rax,0
mov rdi,0
lea rsi, [rel age]
mov rdx,4
syscall

;//Affichage du résultat
mov rax,1
mov rdi,1
lea rsi, [rel msg2]
mov rdx,len2
syscall

mov rax,1
mov rdi,1
lea rsi,  [rel age]
mov rdx,4
syscall

;Sortie système
mov rax,60
xor rdi,rdi
syscall