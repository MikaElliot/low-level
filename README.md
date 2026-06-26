# Assembleur NASM x86-64 — Notes & Programmes

Apprentissage de l'assembleur NASM sur architecture x86-64 (Linux).  
Chaque programme illustre un concept fondamental : syscalls, registres, conversions ASCII, boucles, buffer mémoire.

---

## Prérequis

```bash
sudo apt install nasm
```

---

## Compilation & exécution

```bash
# 1. Assembler
nasm -f elf64 programme.asm -o programme.o

# 2. Lier
ld programme.o -o programme

# 3. Exécuter
./programme
```

> Utiliser `ld` directement plutôt que `gcc -nostdlib` pour éviter les erreurs PIE (Position Independent Executable).

---

## Structure d'un programme NASM

```asm
section .data       ; données initialisées (messages, constantes)
section .bss        ; données non initialisées (réservations mémoire)
section .text       ; code exécutable

global _start
_start:
    ; ... instructions ...

    mov rax, 60     ; sys_exit
    xor rdi, rdi    ; code retour = 0
    syscall
```

---

## Syscalls Linux utilisés

| `rax` | Nom | `rdi` | `rsi` | `rdx` |
|---|---|---|---|---|
| `0` | `sys_read` | fd (0 = stdin) | adresse buffer | nb octets à lire |
| `1` | `sys_write` | fd (1 = stdout) | adresse buffer | nb octets à écrire |
| `60` | `sys_exit` | code retour | — | — |

---

## Registres x86-64

```
63                32 31          16 15    8 7      0
[                  ][              ][  ah  ][  al  ]  ← rax
[                       ebx                        ]  ← sous-partie 32 bits
[                   bx             ]               ]  ← sous-partie 16 bits
```

| 64 bits | 32 bits | 16 bits | 8 bits haut | 8 bits bas |
|---|---|---|---|---|
| `rax` | `eax` | `ax` | `ah` | `al` |
| `rbx` | `ebx` | `bx` | `bh` | `bl` |
| `rcx` | `ecx` | `cx` | `ch` | `cl` |
| `rdx` | `edx` | `dx` | `dh` | `dl` |

**Rôles conseillés**

| Registre | Usage |
|---|---|
| `rax` | syscall number / accumulateur / dividende |
| `rbx` | sauvegarde (non écrasé par syscall) |
| `rcx` | compteur / diviseur |
| `rdx` | reste de division / taille buffer |
| `rdi` | 1er argument syscall (fd) |
| `rsi` | 2ème argument syscall (adresse buffer) |
| `r12`–`r15` | sauvegardes longue durée (jamais écrasés par le noyau) |

> Un syscall Linux peut écraser `rax`, `rcx` et `r11`. Les autres registres sont préservés.

---

## Adressage RIP-relatif

En mode 64 bits, toutes les références mémoire doivent être **relatives à RIP** pour être compatibles PIE.

```asm
; ✗ adresse absolue 32 bits → erreur PIE
mov rsi, num1

; ✓ adresse relative à RIP → compatible
lea rsi, [rel num1]
```

`lea` (Load Effective Address) charge l'**adresse** d'une variable, pas son contenu.  
`[rel ...]` indique à NASM d'encoder un offset relatif au pointeur d'instruction courant.

---

## Conversion ASCII ↔ entier

Les chiffres ASCII ont un décalage fixe de 48 (`'0'` = 48) par rapport à leur valeur numérique.

```
Chiffre   ASCII
  '0'  =   48
  '1'  =   49
  ...
  '9'  =   57
```

**ASCII → entier** (pour calculer)

```asm
movzx eax, byte [rbx]   ; charge le caractère (ex: '3' = 51)
sub al, '0'             ; 51 - 48 = 3  ← valeur numérique
```

**Entier → ASCII** (pour afficher)

```asm
; al = 7 (valeur numérique)
add al, '0'             ; 7 + 48 = 55 = '7' ← caractère affichable
```

> `sys_read` stocke directement des caractères ASCII. Si on veut juste réafficher la saisie, aucune conversion n'est nécessaire.

---

## Réservation mémoire

```asm
section .bss
    input resb 8    ; réserve 8 octets
```

**Calcul de la taille à réserver**

```
resb = nombre max de chiffres + 1 (\n) + 1 (\0)
```

| Valeur max | Chiffres | `\n` | `\0` | `resb` |
|---|---|---|---|---|
| 9 | 1 | 1 | 1 | 3 |
| 99 | 2 | 1 | 1 | 4 |
| 9999 | 4 | 1 | 1 | 6 |
| 999999 | 6 | 1 | 1 | **8** |

> Trop petit → buffer overflow (écrasement des données voisines).  
> Trop grand → gaspillage mémoire.

---

## Terminateurs de chaîne

```asm
msg db "Bonjour", 0     ; 0x00 — terminateur style C (pour printf, strlen)
msg db "Bonjour", 10    ; 0x0A — saut de ligne intégré (\n)
msg db "Bonjour"        ; rien  — longueur gérée par equ $ - msg
```

Avec `sys_write`, seule la **longueur explicite** compte — le terminateur n'est pas lu.  
Le `,0` est utile uniquement si une fonction C doit lire la chaîne.

---

## Conversion d'un nombre multi-chiffres

### Entier → chaîne affichable (droite vers gauche)

```asm
; Principe pour 3450 :
; 3450 ÷ 10 = 345  reste 0  → '0'
; 345  ÷ 10 = 34   reste 5  → '5'
; 34   ÷ 10 = 3    reste 4  → '4'
; 3    ÷ 10 = 0    reste 3  → '3'
; On écrit de droite à gauche, puis on relit de gauche à droite

int_to_str:
    mov rcx, rdi
    add rcx, 15             ; pointe vers la fin du buffer
    mov byte [rcx], 10      ; \n
    dec rcx
    mov rbx, 10             ; diviseur

.loop:
    xor rdx, rdx
    div rbx                 ; rax = quotient, rdx = reste
    add dl, '0'             ; reste → ASCII
    mov [rcx], dl
    dec rcx
    test rax, rax
    jnz .loop

    inc rcx                 ; repositionne au début du nombre
    lea rsi, [rcx]
    lea rdx, [rdi + 16]
    sub rdx, rsi            ; longueur = fin - début
    ret
```

### Chaîne → entier (pour calculer)

```asm
; Principe pour "3450" :
; rax = 0
; rax = 0  × 10 + 3 = 3
; rax = 3  × 10 + 4 = 34
; rax = 34 × 10 + 5 = 345
; rax = 345× 10 + 0 = 3450

str_to_int:
    xor rax, rax

.loop:
    movzx rbx, byte [rsi]
    cmp bl, 10              ; \n ?
    je  .done
    cmp bl, 0               ; \0 ?
    je  .done
    sub bl, '0'
    imul rax, rax, 10
    add rax, rbx
    inc rsi
    jmp .loop

.done:
    ret
```

---

## Pièges courants

| Erreur | Cause | Solution |
|---|---|---|
| `R_X86_64_32S` erreur PIE | `mov rsi, label` au lieu de `lea` | Utiliser `lea rsi, [rel label]` |
| Segmentation fault | `section .code` au lieu de `.text` | Écrire `section .text` |
| Résultat affiché incorrect | `add al, '0'` sur une valeur déjà ASCII | Ne convertir que les entiers bruts |
| Buffer overflow | `resb` trop petit | Compter chiffres + `\n` + `\0` |
| Caractères parasites | `len equ $ - msg` compte le `\0` | Déclarer `len` avant le `db 0` |

---

## Architecture Von Neumann vs Harvard

| Modèle | Description | Limitation |
|---|---|---|
| Von Neumann | Mémoire données et instructions unifiée | Goulot d'étranglement (un seul bus) |
| Harvard | Mémoires séparées | Plus complexe à implémenter |
| **Hybride** | Base Von Neumann + caches séparés L1i/L1d | **Utilisé aujourd'hui** |

---

## Cycle d'exécution du processeur

```
Fetch → Decode → Execute → Write back
  ↑                                ↓
  └────────────────────────────────┘
```

| Étape | Description |
|---|---|
| Fetch | Lecture de l'instruction en mémoire |
| Decode | Identification de l'opération (MOV, ADD, JMP...) |
| Execute | Calcul réel dans l'UAL |
| Write back | Enregistrement du résultat dans un registre ou en mémoire |