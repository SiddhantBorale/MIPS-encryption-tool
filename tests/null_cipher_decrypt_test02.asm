.data
plaintext2: .ascii "garbagetrash"
overrun2: .asciiz "I can see you."
ciphertext2: .asciiz "Where is the best school in New York?"
# decrypts to: stonY
.align 2
indices2: .word 0, 2, 1, 0, 5, 2, 0, 1
num_indices2: .word 8

.text
.globl main
main:
la $a0, plaintext2
la $a1, ciphertext2
la $a2, indices2
lw $a3, num_indices2
jal null_cipher_sf
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
