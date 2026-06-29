
; // Définition:
; Une mémoire c'est un array qui pointe vers des adresses et ayant une capacité fixe de 8bit par case
; l'adresse est fixe et depend de l'architecture du microprocesseur (sur 16bits, 32 bits ou 64bits)

;// Tableau des espaces d'adressage
; La taille max d'une adresse dépend de l'architecture; sur n bits, 2^n

; / ::::::::::::::::: Capacité max ::::::::::::::::::::::/
;  |  taille d'adresse  |  Nombre d'adresses  |  Espace mémoire adressable  |
;  |--------------------|---------------------------|-----------------------------|
;  |       8bits        |          2^8 = 256        |           256 octets        |
;  |--------------------|---------------------------|-----------------------------|
;  |       16bits       |       2^16 = 65 536       |           64 Kio            |
;  |--------------------|---------------------------|-----------------------------|
;  |       32bits       |    2^32 = 4,29 milliard   |           4Gio              |
;  |--------------------|---------------------------|-----------------------------|
;  |       64bits       |    2^64 = 1,84 x 10^19    |           256 octets        |
;  |--------------------|---------------------------|-----------------------------|



; la taille de chaque case est fixe: 8bits
;// ::::::::::: Mémoire ::::::::::::::::
;  |     Adresse     |     Données     |
;  |-----------------------------------|
;  |    0x7FFFA123   |    01001100     |
;  |    0x7FFFA124   |    01001101     |
;  |    0x7FFFA125   |    01001110     |
;  |    ----------   |    --------     |


;// Réprésentation conceptuel d'une grille de mémoire
;
; [_][_][_][_][_][_][_][_][_][_][_][_][_][_][_][_][_][_]
; [_][_][_][_][_][_][_][_][_][_][_][_][_][_][_][_][_][_]
; [_][_][_][_][_][_][_][_][_][_][_][_][_][_][_][_][_][_]

; chaque case a une capacité de 8bits ou 1 byte (1 octets)
; chaque case est adressé selon l'architecture du processeur


; Une pipeline CPU - RAM se fait comme suit
; 1- lecture du données en RAM
; 2- Placement dans la régistre
; 3- Operation au niveau du CPU
; 4- Placement dans la registre
; 5- Stockage en RAM

; Il y a une très grande différence de rapidité entre le RAM et les registres
; registres: très petit, mais très rapide
; RAM: plus volumineux, mais moins rapide
; donc il y une mémoire intermédiaire entre le CPU et le RAM, ce sont les caches
;
; |  RAM  | ---- |  Caches L1-L2-L3  | ---- |  CPU  |

;// Lecture en mémoire:
mov rax, [0x2000]
;envoie la valeur de rax à l'adresse mémoire 0x2000

;// Ecriture en mémoire:
mov [0x1000], rax
;cela signifie copie la valeur de rax à l'adresse 0x1000

;// Taille de données en mémoires
;  byte: 1
; word: 2
; dword: 4
; qword: 8

;// Exemple:
mov al, [0x1000]    ;1 byte
mov ah, [0x1000]    ;2 byte
mov eax, [0x1000]    ;4 byte
mov rax, [0x1000]    ;8 byte


;Le PIE: idée de base du PIE
; Normalement, un programme classique est chargé à une adresse fixe

; Exemple:
; Sans PIE: 0x00400000 - pointe vers le début du programme
; Avec PIE: 0x55a3c2f100000 (ou autre adresse aléatoire) - adresse variable à chaque execution

; Pourquoi ? Pour des mésures de sécurité:
; Sans PIE: un attaquant connait les adresses. Il peut faire du bufferoverflow plus facilement.
; Avec PIE: impossible de prédire où est le code.

; C'est une protection contre:
; -bufferoverflow
; -ROP (Return Oriented Programming)
; -exploitation mémoire



;// Organisation mémoire d'un programme
; Quand un programme s'execute, le système lui donne une zone mémoire organisé comme ceci:

;  |:::::::::::::::::::::::::::::::::::|
;  |     1- Code (instructions)        |
;  |-----------------------------------|
;  |     2- Données globales           |
;  |-----------------------------------|
;  |     3- Heap (dynamique)           |
;  |-----------------------------------|
;  |     4- Stack (pile)               |
;  |:::::::::::::::::::::::::::::::::::|

;:::::::::::::: CODE ::::::::::::::::::::::
; 1- Le segment CODE (text segment)
; :::::::::::::::::::::::::::::::::::::::::
; C'est la partie qui contient: les instructions du programme et les fonctions
; Exemple:
;`
;   int main() {
;       return 0;
;   }
;`
; En mémoire: 0x4010000: mov eax, 0
;             0x4010005: ret  

;:::::::::::::: DATA ::::::::::::::::::::::
; 2- Les données globales (data segment)
; :::::::::::::::::::::::::::::::::::::::::
; C'est le segment qui contient les variables globales initialisées et variables statiques
; Exemple:
;`
;    int x = 10;
;    static int y = 20;
;    int a;
;`
; En mémoire: 0x404000: x = 10
;             0x404004: y = 20
;             0x404005: a (reservation d'une case)

; Sous-parties:
; .data: variables initialisées
; .bss: variables non initialisées

;:::::::::::::: HEAP ::::::::::::::::::::::
; 3- Le Heap
; :::::::::::::::::::::::::::::::::::::::::
; C'est une mémoire dynamique, zone utilisé pour des allocations dynamiques (malloc en C, new en C++)
; Le Heap grandit vers le haut: 0x500000 - 0x600000 - ...
; Exemple:
;`
;   int *p = malloc(4);
;`
; En mémoire: Heap: 0x0500000 [4bytes alloués]
;

;:::::::::::::: STACK ::::::::::::::::::::::
; 3- Le stack
; :::::::::::::::::::::::::::::::::::::::::
; Ou la pile, c'est une zone en mémoire utilisé pour:
; les fonctions
;les variables
;localesn
;les appels fonctions
;les retours d'adresses
; Le stack grandit vers le bas: 0x7FFFFF - 0x770000 - ....

;Exemple:
;`
;   void f() {
;       int a = 5;
;   }
;`
; En mémoire: stack frame de f: 0x7ffd000: a = 5