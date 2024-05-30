.data
plaintext1: .ascii "gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg"
overrun1: .asciiz "Computer Science"
ciphertext1: .asciiz "Wspoethad,mhtrv etie aeuoev ,nsmnndglea  !a!eeryrtme n*vna y yxs *etmc n pio*rs oliblgh*  ldagroh *"
# decrypts to: Whenever students program lovely code very late at night, my brain explodes! sigh, man oh man!
.align 2
nr1: .word 11
nc1: .word 9

.text
.globl main
main:
la $a0, plaintext1
la $a1, ciphertext1
lw $a2, nr1
lw $a3, nc1
jal transposition_cipher_sf
la $a0, plaintext1
li $v0, 4
syscall
li $a0, '\n'
li $v0, 11
syscall

la $a0, overrun1
li $v0, 4
syscall

li $v0, 10
syscall

.include "../hw9.asm"
