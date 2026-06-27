;//Addition signé de valeur sur une plage de 32 bits

section .data
msg db "Le résultat est: ",0
msg_len equ $ - msg
newline db 10

section .bss
buffer resb 16

section .text
global _start
_start:

mov eax, -3498987
;le cpu effectue le complément à 2 automatiquement
mov ebx, 12897
add eax, ebx

;//Sauvegarde du résultat (pour réutiliser rax)
push rax

;//Afficher le message
mov rax,1
mov rdi,1
lea rsi, [rel msg]
mov rdx,msg_len
syscall

;//Conversion en ASCII
pop rax
lea rdi, [rel buffer]
call conversion

;//Affichage du résultat
mov rax,1
mov rdi,1
lea rsi, [rel buffer]
;mov rdx ?
;la valeur de rdx est défini dans la conversion
syscall

;//Saut de ligne
mov rax,1
mov rdi,1
lea rsi, [rel newline]
mov rdx,1
syscall

;//sortie système
mov rax,60
xor rdi,rdi
syscall

;//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;//Function conversion int (signed 32 bits) to string (pour afficher le résultat)
;Entrées: eax = valeur à convertir
;         rdi = adresse du buffer de sortie
;Sortie:  rdx = longueur de la string (arg du sys_write)
;Registres modifiées: eax, ebx, ecx, edx, rdi

;//Principe:
;1 - Si négatif: écrire '-', prendre la valeur absolue
;2 - Diviser repetitivement par 10, les chiffres sortent à l'envers
;3 - Empiler chaque chiffre sur le stack
;4 - Dépiler dans le buffer - remise en ordre
;//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


;//Int to string
conversion:
    push rbp
    mov rbp, rdi
    ;mémoriser le début du buffer
    xor ecx,ecx
    ;remise à 0
    ;ecx: compteur de chiffres empilés

;//Cas zero
    test eax, eax
    jnz .check_sign
    ;jump conditionnel (if !0)
    mov byte [rdi], '0'
    mov rdx,1
    pop rbx
    ret

;//Vériication du signe
.check_sign:
    jns .extract
    ;jump conditionnel (if not sign (positif))
    mov byte [rdi], '-'
    inc rdi
    neg eax ;valeur absolue
    ; neg sur un entier signé 32 bits :
    ; -350000 en complément à deux → neg → 350000
    ; cas limite : neg(-2147483648) = -2147483648 (overflow silencieux)

;//Extraction
.extract:
    mov ebx,10
    ;décimal: base 10

;//Boucler la conversion
.loop:
    xor edx,edx
    ;vider edx avant la division
    div ebx
    ;eax = quotient
    ;edx = reste
    add dl, '0'
    ;conversion
    push rdx
    ;empiler à l'envers
    inc ecx
    test eax,eax
    jnz .loop
    ;condition de la boucle (!0, boucle)

;//Remise en ordre (boucler la récupération de la pile)
.unstack:
    pop rdx
    mov byte [rdi], dl
    inc rdi
    loop .unstack
    ; longueur = position actuelle - début du buffer
    mov rdx,rdi
    sub rdx,rbp
    pop rbp
    ret