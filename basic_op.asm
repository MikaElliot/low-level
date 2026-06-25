;//constantes
section .data
;section .data: correspondant aux données initialisés
msg db "Le résultat est:",0
;caractère de fin \0
;comme une chaine C
msg_len equ $ - msg
  
;//reservations
section .bss
;section .bss: correspondant aux données non initialisés
;zone pour la mémoire vide réservé
buffer resb 16
;reservation de 16octets = 16 * 8bits
;pourquoi 16octets ?
;il faut trouver le nombre confort
;reservation de mémoire très petit === bufferoverflow
;reservation de mémoire trop grand === gaspillage de mémoire

section .text
global _start
_start:

;//opérations
mov eax,3400
add eax,50
;addition de 3400 + 50
;eax est une registre sur 32bits (pourquoi eax et non rax ? pour éviter le gespillage)

;//sauvegarde
mov ebx,eax
;copie du résultat dans ebx
;pourquoi ?
;on libère le registre eax pour effectuer d'autres opérations
;alors on garde une copie du résultat

;//initialisation du buffer
mov rdi, buffer + 15
;on se place à la fin du buffer car on va écrire le nombre de droite à gauche
mov byte [rdi],0
;on met une caractère de fin \0
;comme une chaine C

dec rdi
;on récule d'une case pour commencer à écrire le nombre, car buffer + 15 est réservé pour le caractère \0
;donc on commence à écrire à partir de buffer + 14

;//Conversion en ASCII
;pour afficher les nombres à l'écran, il est nécessaire de convertir les caractères en ASCII ou en UTF-8
;car les valeurs sont stockées en binaire initialement
;Donc pour une sortie standart, il est impératif de faire la conversion
;NB: Pour une affichage dans un mode graphique (GPU, framebuffer), la conversion n'est pas nécessaire
;car on peut écrire directement sur les pixels

mov eax,ebx
;on remet le résultat dans le registre eax
mov ecx,10
;base décimal = 10
;ecx ne sert que de diviseur, on ne l'utilise pas comme pointer

;//Boucle
convert_loop:
xor edx,edx
;remise à 0 de edx;

div ecx
;Division eax par ecx (eax/10)
;quotion eax
;reste edx
;Exemple: 3450
;1er boucle : 3450 / 10 = 345;  quotient: 345, reste: 0 -- eax = 345 et edx = 0
;2eme boucle: 345 / 10 = 34;    quotient: 34, reste: 5 -- eax devient 34 et edx = 5
;3eme boucle 34 / 10 = 3;       quotient: 3, reste 4 -- eax devient 3 et edx = 4
;4eme boucle 3 / 10 = 0;        quotiont: 0, reste 3 -- eax devient 0 et edx = 3
;ensuite ecriture de droite vers gauche;
; [] [] [] []
;         -0
;       -5
;    -4
; -3

add dl, '0'
;:::::::::::1er boucle [edx = 0 dl = 0] :::::::::::::
;on ajoute '0'; '0' = 48 en décimal
;                   = 0x30
;                   = 00110000 en binaire
;pourquoi ? car en ASCII:
;0 = 48
;1 = 49
;2 = 50
;3 = 51
;4 = 52
; ...

;:::::::::::1er boucle [edx = 5 dl = 5] :::::::::::::
;on ajoute '0'; '0' = 48 en décimal
;                   = 0x30
;                   = 00110000 en binaire
;donc 5 + 48 = 53
;5 = 53 en AS

;::::::::::: Ainsi de suite pour les autres boucles :::::::::::::

;Pourquoi explicitement du ASC?
;Les codes pour représenter les nombres sont identiques en ASCII et UTF-8
;Les 128 premiers caractères ASCII sont identiques à celui d'UTF-8

mov [rdi], dl
;utilisation de ecx comme adresse; c'est pourquoi on utilise les crochets: acceder à une mémoire
;Exemple: ecx = 0x100E, dl = '0'
;Ox100A '0'

dec rdi
;décrementer ecx; switch entre les adresses
; 0x100A '0'
; 0x100B '5'
; 0x100C '4'
; 0x100D '3'

test eax,eax
jnz convert_loop
;condition de la boucle (test logique AND)
;met à jour le flag:
;ZF= Zero Flag
;CF= Carry Flag
;OF= Overflow Flag
;SF= 

;logique AND (1 if onl y x = y)

;ensuite test la condition jnz (jump if not zero)
;check ZF; if not 0: revient à convert_loop (boucle)
;          if 0: sort de laboucle
;1er boucle: eax:345
;test eax,eax = 345 and 345 (1 et 1 = 1, donc ZF = 0)
;check condition jnz (ZF=0, retour à la boucle )

;2eme boucle: eax:34
;test eax,eax = 34 and 34 (1 et 1 = 1, donc ZF = 0)
;check condition jnz (ZF=0, retour à la boucle )

;3eme boucle: eax:3
;test eax,eax = 3 and 3 (1 et 1 = 1, donc ZF = 0)
;check condition jnz (ZF=0, retour à la boucle )

;4eme boucle: eax:0
;test eax,eax = 0 and 0 (0 et 0 = 0, donc ZF = 1)
;check condition jnz (ZF=1, sort de la  boucle )

inc rdi
;repositionnement au début du nombre;
;dans le programme, ecx pointe vers la fin du buffer
;ex: début du buffer - [_] [_] [_] [_] [_] [_] [_] [_] [_] [_] [_] [_] -fin du buffer
;on se position à la fin du buffer pour écrire les valeurs (de doite à gauche)
;[_] [_] [_] [_] [_] [_] [_] [+] [3] [4] [5] [0] [+]
;à la fin de la boucle ecx pointe sur une position avant le début du nombre;
;ex: le nombre commence à buffer + 12; positionnement à buffer + 11 qui pointe sur une caractère vide
;donc on repositionne par incrementation à 1
;sans repositionnement, que se passerait-il ?
;affichage de caractère vide ou un ancien contenu du mémoire ou des caractères garbages

;sauvegarde de l'adresse
push rdi
;sauvegarde de l'adresse avant syscall
;push: envoi sur le stack
;pop: récuperation
;mécanisme LIFO (Last In First Out)
;adresse du début
;                   [3] [4] [5] [0]
; adresse du début  -|

;//Affichage
mov rax,1
mov rdi,1
mov rsi,msg
mov rdx,msg_len
syscall
;Explication dans basic_out.asm

;//Affichage du résultat
pop rsi
;récuperation de l'adresse du début depuis le stack
mov rax,1
mov rdi,1

;//calcul de la longueur
;longueur = adresse de fin - adresse de début

mov rdx, buffer + 15 ;fin
;adresse de fin: dérnière case du buffer (avant le \0)
sub rdx, rsi
;Ex: rsi = buffer + 11
;buffer + 15 - buffer + 11 = 4 caractères
syscall

;retour systeme
mov rax,60
;sys_exit
xor rdi,rdi
;remise à 0
syscall