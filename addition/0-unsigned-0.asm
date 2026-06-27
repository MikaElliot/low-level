;//Addition simple, resultat entre 0 à 9
section .data
num1 db 3
num2 db 4
result db 0

section .text
global _start
_start:
mov ax, [rel num1]
;aller à l'adresse relative à num1 et mettre la valeur contenue dans ax
;rel ax, [rel num1] : pointer la valeur de l'adresse num1 à ax
mov bx, [rel num2]

add ax,bx
;Addition de 3 + 4 = 7
add ax,'0'
;conversion en ASCII
;7 + 'O' (0 = 48 en ASCII)
;7 + 48 = 55 ('7' en ASCII)

;no-pie
; mov [result], ax

;RIP-relative
lea rbx, [rel result]
mov [rbx], ax

;//Affichage
mov rax,1
mov rdi,1
lea rsi,[rel result]
mov rdx,1
syscall

;//sortie système
mov rax,60
xor rdi,rdi
syscall

;1//
;Lors de la compilation, on obtient une erreur d'adressage, parce que linux fonctionne avec un mode de compilation où l'executable peut-être chargé à une adresse mémoire aléatoire (PIE), donc il faut désactiver PIE pour faire fonctionner le programme ou réécrire le programme en tenant compte des adressage relatives.
;PIE: Position Independant Executable. C'est une mésure de sécurité par défaut moderne.

;compilation: gcc -nostdlib -no-pie input.o -o output