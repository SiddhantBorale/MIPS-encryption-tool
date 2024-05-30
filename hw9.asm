.data
plaintext2: .ascii "garbagetrash"
overrun2: .asciiz "I can see you."
ciphertext2: .asciiz "Where is the best school in New York? Yes"
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

# $a0: pointer to plaintext buffer
# $a1: pointer to ciphertext string
# $a2: pointer to indices array
# $a3: num_indices

# register conventions:
# $t0: current index in indices array
# $t1: current index in ciphertext string
# $t2: current index in plaintext buffer
# $t3: current word index
# $t4: current word length
# $t5: flag to indicate whether current word should be skipped (0 = skip, 1 = include)



null_cipher_sf:
    move $t0, $a2         # initialize $t0 to start of indices array
    move $t1, $a1        # initialize $t1 to start of ciphertext string
    move $t2, $a0        # initialize $t2 to start of plaintext buffer
    li $t3, 0x00
    li $t4, 0x00
    li $t5, 0x00
loop:
    li, $t7, 0x00
    lb $t6, 0($t1)             # load current character from ciphertext
    beq $t6, $t7, check  # if null-terminator is reached, exit loop
    addi $t1, $t1, 1           # increment ciphertext pointer
    li, $t7, ' '
    beq $t6, $t7, handle_word  # if space is reached, handle current word
    addi $t4, $t4, 1
    j loop


handle_word:
	li $t6, 0x00
	lw $t7, 0($t0)
	beq $t6, $t7, skip_one 
	addi $t1, $t1, -1
	sub $t1, $t1, $t4     #go to the start of the word
	addi $t7, $t7, -1
	add $t1, $t1, $t7     #increment by the index
	lb $t6, 0($t1)
	sb $t6, 0($t2)
	sub $t1, $t1, $t7 
	add $t1, $t1, $t4
	addi $t1, $t1, 1
	sub $t4, $t4, $t4
	addi $t0, $t0, 4
	addi $t2, $t2, 1
        addi $t5, $t5, 1
	addi $t3, $t3, 1
	j loop
	
	
skip_one:
	addi $t3, $t3, 1
        sub $t4, $t4, $t4
	addi $t0, $t0, 4
	j loop

check:
	addi $t7, $a3, 0
	bgt $t3, $t7, finalize
	addi $t5, $t5, 1
	j last
	
finalize:
    add $t2, $t2, $t3
    add $t2, $t2, $t5	
    addi $t5, $t5, -1
    j end

last:
	li $t6, 0x00
	lw $t7, 0($t0)
	beq $t6, $t7, skip_one
	sub $t1, $t1, $t4 #go to the start of the word
	addi $t7, $t7, -1
	add $t1, $t1, $t7 #increment by the index
	lb $t6, 0($t1)
	sb $t6, 0($t2)
	sub $t1, $t1, $t7 
	add $t1, $t1, $t4
	addi $t1, $t1, 1
	sub $t4, $t4, $t4
	addi $t0, $t0, 4
	addi $t2, $t2, 1
	sub $t2, $t2, $t3
	addi $t2, $t2, 1
        add $t2, $t2, $t5
   	addi $t5, $t5, -1
	j end
    	
end:
    move $v0, $t5
    li $t7, 0x00
    sb $a0, 0($t2)
    jr $ra	
    
