.data
plaintext2: .ascii "This is garbage memory, trash!!!"
overrun2: .asciiz "Hello there!"
ciphertext2: .asciiz "W ohd you  sdt?oh* i*ys*o *ut*"
# decrypts to: Why do you do this to us?
.align 2
nr2: .word 3
nc2: .word 10

.text
.globl main
main:
la $a0, plaintext2
la $a1, ciphertext2
lw $a2, nr2
lw $a3, nc2
jal transposition_cipher_sf
la $a0, plaintext2
li $v0, 4
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
