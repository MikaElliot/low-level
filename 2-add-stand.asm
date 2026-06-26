section .data
msg1 db "Saisir le premier nombre :",0
;en assembleur, une chaine n'a pas de terminateur automatique
;donc on peut mettre des terminateurs:
;0 : un octect 0x00 à la fin. Les fonctions C (printf, strlen, puts) s'arretent quand elles voient ce 0.
;10 : Saut de ligne integré, 10 = \n en ASCII
len1 equ $ - msg1

msg2 db "Saisir le second nombre :",0
len2 equ $ - msg2

msg3 db "Le résultat est :",10
len3 equ $ - msg3

section .bss
num1 resb 2
num2 resb 2
result resb 2

section .text
global _start
_start:

;//Saisie du premier nombre
mov rax,1
mov rdi,1
lea rsi, [rel msg1]
;lea ou load effective adress charge une adresse de num1, calculée relativement à RIP
mov rdx,len1
syscall

mov rax,0
mov rdi,0
lea rsi, [rel num1]
mov rdx,2
syscall

;//Saisie du second nombre
mov rax,1
mov rdi,1
lea rsi, [rel msg2]
mov rdx,len2
syscall

mov rax,0
mov rdi,0
lea rsi, [rel num2]
mov rdx,2
syscall

;//Conversion en ASCII
lea rbx, [rel num1]
;chargement de la valeur
movzx eax, byte [rbx]
;move with Zero Extension
;lecture à l'adresse rbx
;byte: lit exectement 1 octet et remplit les bits restants avec des Zero
;pourquoi byte ?
;Un caractère (chiffre) en ASCII tient sur un octet
sub al, '0'
;conversion

lea rbx, [rel num2]
movzx ecx, byte [rbx]
sub cl, '0'

;//addition
add al, cl
;operation d'addition des contenus des regisres à partir du lower
;décomposition rax: registre sur 64bits; eax: registre sur 32bits; ax: registre sur 16bits
;ah et al: registre sur 8bits ou un byte (octet)
;les caractères en ASCII tiennent sur un octet, d'où l'utilisation des registres lower sur 8bits

;Conversion du résultat
add al, '0'
lea rbx, [rel result]
;rbx devient l'adresse de result
mov byte [rbx], al
;ecrire la valeur de al (resultat) à cette adresse
mov byte [rbx + 1], 10
;ecrire le saut de ligne dans le buffer
;10 saut de ligne


;afficher le résultat
mov rax,1
mov rdi,1
lea rsi, [rel msg3]
mov rdx,len3
syscall

mov rax,1
mov rdi,1
lea rsi, [rel result]
mov rdx,2
syscall

;sortie
mov rax,60
xor rdi,rdi
syscall