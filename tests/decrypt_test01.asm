.data
plaintext1: .ascii "???????????"
overrun1: .asciiz "Peek-a-boo!"
ciphertext1: .asciiz "Wspoethad,mhtrv etie aeuoev ,nsmnndglea  !a!eeryrtme n*vna y yxs *etmc n pio*rs oliblgh*  ldagroh *"
# decrypts to: Welovemips
.align 2
nr1: .word 11
nc1: .word 9
indices1: .word 1, 5, 0, 5, 2, 1, 4, 0, 0, 1, 4, 3, 1
num_indices1: .word 13

.text
.globl main
main:
la $a0, plaintext1
la $a1, ciphertext1
lw $a2, nr1
lw $a3, nc1
addi $sp, $sp, -8
la $t7, indices1
sw $t7, 4($sp)
lw $t7, num_indices1
sw $t7, 0($sp)
li $t7, 5551234  # trashing $t7
jal decrypt_sf
addi $sp, $sp, 8
move $s0, $v0
la $a0, plaintext1
li $v0, 4
syscall
li $a0, '\n'
li $v0, 11
syscall

move $a0, $s0
li $v0, 1
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
