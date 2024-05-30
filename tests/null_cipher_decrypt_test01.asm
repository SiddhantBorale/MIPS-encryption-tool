.data
plaintext1: .ascii "@@@@@@@@@@@"
overrun1: .asciiz "This should be readable."
ciphertext1: .asciiz "Whenever students program lovely code very late at night, my brain explodes! sigh, man oh man!"
# decrypts to: Welovemips
.align 2
indices1: .word 1, 5, 0, 5, 2, 1, 4, 0, 0, 1, 4, 3, 1
num_indices1: .word 13

.text
.globl main
main:
la $a0, plaintext1
la $a1, ciphertext1
la $a2, indices1
lw $a3, num_indices1
jal null_cipher_sf
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
