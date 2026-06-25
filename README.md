#Assembleur (NASM)
───────────
Assembleur est le langage le plus proche du processeur qu'un humain peut écrire facilement (pas si facilement que ça).
Il fournit une représentation lisible du langage machine c-a-d que chaque instruction assembleur correspond généralement à une ou plusieurs instructions machine.

#Pourquoi apprendre l'assembleur vis-à-vis des nouvelles technologies en emergences ?
──────────────────────────────────────────────────────────────────────────────────────

Pour comprendre:

-Le fonctionnement réel de l'ordinateur
-L'execution des programmes et du processeur
-Les compilateurs
-Le système d'exploitation
-Le développement embarqué
-Le reverse ingeneering
-Le débogage avancé
-La performance maximale d'une application

#Fonctionnement au niveau du système
────────────────────────────────────
Modèle de Von Neumann

Processeur  |    Memoires   |    Périphériques

Limitation du modèle:
────────────────────
-Mémoire données et mémoire instructions dans une mémoire unique
-Cela a créé des bouchons (goulot de Neumann)

Solution:
─────────
Modèle de Harvard
-Architecture différente
-Séparation de la mémoire données et mémoires instructions

Solution optimisée:
───────────────────
Modèle Hybride
C'est l'architecture utilisé actuellement, basé sur le modèle de Neumann,
mais en séparant les mémoires données et mémoires instructions

Ex: mov AL,61h En binaire: 10110000 01100001 ... En hex: [1011: B 0000:0 0110:6 0001:1] 1B 61 ...

#Fonctionnement au niveau du processeur
───────────────────────────────────────
CPU --- Registres --- Caches --- RAM --- HDD/SSD

#Processeur
───────────
composé de -UAL -UC -Registres -Caches(L1,L2,L3)

Architectures:
──────────────
x86 (intel, AMD): registres eax:32bits
x86-64 (extension 64bits): registres rax:64bits
ARM (smartphones, rapsberry Pi): archi très utilisé en mobile
ARM-64/Aarch-64 (extension 64bits): version moderne d'ARM utilisé par Android, Apple
RISC-V (Open source): archi simple et récente
MIPS (anciens systèmes): utilisé pour apprendre
Power-PC (Apple ancien): utilisé dans les anciens consoles et MAC

#Cycle de fonctionnement du processeur
──────────────────────────────────────
-Fetch: Lecture de l'instruction
-Décode: Determination de l'operation (MOV,ADD,JMP, ...)
-Execute: Execution réel (calcul, ex: 5+7)
-Write back: Enregistrement des résultats

#Mémoires
─────────
-Unité de stockage
Mémoire de travail: directement utilisé par le CPU
Ex: Registres, caches, ram
Mémoires sécondaires: stockage persistant du système
Ex: HDD, Flash
Mémoires spécial: mémoires dédiés
Ex: vram, buffers réseaux, mémoires EEPROM

-Sous-système d'accès aux données:
────────────────────────────────
            Mémoire
────────────────────────────────
 Adresse        | Données
────────────────────────────────
 0xc001         | 100101
────────────────────────────────
 0xc010         | 100110
────────────────────────────────

#Registres
──────────
Dépend de l'archi (64bits, 32bits, 16bits)
───────────────────────────────────────────────────
                    rax
───────────────────────────────────────────────────
|                    |               eax
|                    ───────────────────────────────
|                    |            |       ax
|                    |            ───────────────────
|                    |            |    ah    |   al
|                    |            ───────────────────
|─64bits             |            |          |
                     |─32bits     |          |
                                  |─16bits   |
                                             |─8bits
Il existe 3 types:
-Registres généraux:
rax (accumulateur), rbx(base), rcx(compteur), rdx(données)
rdi (destination), rsi (source)
rbp (base de pile), rsp (sommet de pile)
-Registres de segments:
cs (code), ss (stack), ds (données), es, fs, gs (données suppl.)

---

Compilation:
1-Assembler
```
nasm -f alf64 basic_out.asm -o basic_out.o
```

2-Lier
```
gcc -nostdlib basic_out.o -o basic_out
```

3-Executer
```
./basic_out
```