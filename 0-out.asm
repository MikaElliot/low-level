;Ecriture dans le format .data
section .data
;section .data: correspondant aux données initialisés
;section .text: correspondant au code
;section .bss: correspondant aux données non initialisés

;création d'une variable message_user
message_user db "Afficher du texte sur assembleur",10
;on assigne la taille
;                   db:define bytes [1 octet, 8bits]
;                   dw:define word [2 octets, 16bits]
;                   dd:define double word [4 octets, 32bits]
;                   dq:define quadri word [8 octets, 64bits]
;10: retour à la ligne

;création d'une constante len
len equ $ - message_user
;equ: mot-clé pour assignation d'une constante ["equivalent à ..."]
;$: adresse actuel dans le code

;ecriture du code
section .text

;indication au linker
global _start

;point d'entrée du programme
_start:

mov rax,1
;rax: accumulateur
;1: sys_write (ecriture)
;0: sys_read (lecture)
;60: sys_exit (quitter)
;quand on fait un mov rax,1
;on demande au système d'ecrire quelque chose dans le terminal sys_write
;write() a besoin de 3 paramètres: fd, buffer, size
;fd = destination (rdi)
;buffer = adresse du texte (rsi)
;size = longueur du texte (rdx)

mov  rdi,1
;premier argument du syscall
;1=stdout (terminal)
;rdi: registre de destination

mov rsi,message_user
;deuxième argument du syscall
;rsi pointe vers "Afficher du texte sur assembleur"
;Ex: 0x400000 -> A
;Ex: 0x400001 -> f
;Ex: 0x400010 -> f
;Ex: 0x400011 -> i
;Ex: 0x400100 -> c
;Ex: 0x400101 -> h
;Ex: 0x400110 -> e
;Ex: 0x400111 -> r
;......
;rsi: registre de source

mov rdx,len
;troisième argument du syscall
;rdx: registre de taille

syscall
;instruction pour passer en mode kernel
;2 modes: user et kernel
;ici s'effectue la lecture:
;RAX = 1 --> write()
;RDI = 1 --> stdout (terminal)
;RSI = message_user (source)
;RDX = len (longueur)
;Puis execute write(1, "Afficher du texte sur assembleur\n",8)
;Resultat affiché à l'ecran

mov rax,60
;60=exit
;Terminer le programme

xor rdi,rdi
;remet rdi à O
;indiquer une sortie normale (success)

syscall
;mode kernel
;execute exit(0)b

;:::::::::::: Tous les arguments du syscall :::::::::::::
;arg 1: rdi
;arg 2: rsi
;arg 3: rdx
;arg 4: r10
;arg 5: r8
;arg 6: r9