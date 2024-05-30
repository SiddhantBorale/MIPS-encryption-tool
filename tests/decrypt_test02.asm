.data
plaintext2: .ascii "Systems"
overrun2: .asciiz "You should be able to read me."
ciphertext2: .asciiz "W t Yht ioehsnrrec ke hN? boe*ieow*ssl *"
# decrypts to: stonY
.align 2
nr2: .word 5
nc2: .word 8
indices2: .word 0, 2, 1, 0, 5, 2, 0, 1
num_indices2: .word 8

.text
.globl main
main:
la $a0, plaintext2
la $a1, ciphertext2
lw $a2, nr2
lw $a3, nc2
addi $sp, $sp, -8
la $t0, indices2
sw $t0, 4($sp)
lw $t0, num_indices2
sw $t0, 0($sp)
li $t0, 1212434  # trashing $t0
jal decrypt_sf
addi $sp, $sp, 8
move $s0, $v0
la $a0, plaintext2
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

la $a0, overrun2
li $v0, 4
syscall

li $v0, 10
syscall

.include "../hw9.asm"
