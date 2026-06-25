;::::::::::::: PROGRAMME ASSEMBLEUR POUR DEMANDER LA SAISIE DE 2 NOMBRES, EFFECTUER L'ADDITION ET AFFICHER LE RÉSULTAT ::::::::::::::::

;// Les données initialisés
section .data
msg1 db "Entrer la première valeur:"
len1 equ $ - msg1

msg2 db "Entrer la deuxième valeur:"
len2 equ $ - msg2

msg3 db "Le résultat est:",
len3 equ $ - msg3

newline db 10
;alternative pour saut de ligne,
;on peut utiliser aussi ,10 en paramètre pour le saut de ligne

;// Les reservations mémoires
section .bss
num1 resb 2
num2 resb 2
result resb 2

section .text
global _start
_start:
;// Demande la saisie premier nombre
mov rax,1
;1: sys_write
;appel write(fd, buffer, size)
mov rdi,1 ;fd
;1 stdout terminal
mov rsi, msg1 ;buffer
mov rdx,len1 ;size
syscall

;// Lecture de la première valeur
mov rax,0
;0: sys_read
;appel read(fd, buffer, size)
mov rdi,0
;stdin: clavier
mov rsi,num1 ;buffer
mov rdx, 2 ;size
;2 signifie: 2 octets pour l'ecriture
syscall

;// Demande la saisie deuxième nombre
mov rax,1
;1: sys_write
;appel write(fd, buffer, size)
mov rdi,1 ;fd
;1 stdout terminal
mov rsi, msg2 ;buffer
mov rdx,len2 ;size
syscall

;// Lecture de la seconde valeur
mov rax,0
;0: sys_read
;appel read(fd, buffer, size)
mov rdi,0
;stdin: clavier
mov rsi,num2 ;buffer
mov rdx, 2 ;size
;2 signifie: 2 octets pour l'ecriture
syscall

;//Conversion ASCII - Entier
mov al, [num1]
sub al, '0'
;0 --- 48 en ASCII
;nb saisi (Ex: 6 --- 54 en ASCII)
;en low level, les valeurs sont par défaut en binaire donc, on doit les convertir en ASCII, car sur le terminal on n'affiche que des caractères
;mov / add, '0' permet le décalage (offset)

mov bl, [num2]
sub bl, '0'

;//Opération
add al,bl

;Conversion en ASCII du résultat
add al, '0'
mov [result], al

;//Affichage du résultat
mov rax,1
mov rdi,1
mov rsi,msg3
mov rdx,len3
syscall

mov rax,1
mov rdi,1
mov rsi,result
mov rdx,2
syscall

;//Saut de ligne
mov rax,1
mov rdi,1
mov rsi,newline
mov rdx,1
syscall

;retour système
mov rax, 60
;exit
xor rdi,rdi
syscall

;NB: la compilation se fait en mode PIE par le système
;PIE: Position Independant Executable

;donc il faut désactiver le mode PIE lors de la compilation
;---------
;Cas 1:
;---------
;gcc -nostdlib -no-pie input.o -o output
;---------
;cas 2: Compiler + linker directement avec ld
;---------
;ld input.o -o output

;Code PIC-compatible dans scan_add_pic.asm