
;//Addition
mov al,4
add al,3 ;resultat: AL = 7

;//Soustration
mov al, 19
sub al, 6 ;resultat: AL = 13
;Si le résultat négatif, le résultat est stocké avec un complément à 2
;Ex: résultat = -5
;complément à 2
;5 en 00001001
;inversion : 11110110 + 1 = 1111011
;1111011 = 35 si non signé et 5 si signé donc qu'est-ce qui fait la différence ?
;Ce sont les FLAGS: si SF=1, négatif; si CF=1, positif

;//Multiplication: MUL et IMUL
;1) MUL (unsigned)
mov al,5
mov bl,3
mul bl ;resulatt AL x BL stocké dans AX ou EAX si 32 bits
;REMARQUE: registre implicite; multiplicande toujours al / ax / eax / rax selon la taille

;2) IMUL (signed)
imul eax,ebx
;gère les nombres négatifs

;Division: DIV / IDIV
mov ax,20
mov bl,3
div bl ;resultat AL: quotient, AH reste
;REMARQUE: registre implicite

idiv bl

;REMARQUE: Avant la division div, il faut remettre à 0 le dx
xor dx,dx ;remise à 0

;INC / DEC
;INC: Incrementation
inc al ;al + 1
dec al ;al - 1

;CMP: Comparaison
;CMP ne stocke pas de résultat, il met à jour les flags
cmp al,10 ;compare la valeur de al et 10, ensuite met à jour les flags
ZF ;zero
CF ;carry
OF ;overflow
SF ;signe

;Logique BIT à BIT
;AND
and al,1
;OR
or al,1
;XOR
xor al,al ;reset rapide
;NOT
not al ;inverse les bits

;SHIFT: Shift left / Shift right
;SHL:
shl al,1 ;multiplie la valeur par 2 Ex: 5 - 10
;SHR:
shr al,1 ;divise la valeur par 2 Ex: 10 - 5