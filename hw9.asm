# $a0: pointer to plaintext buffer
# $a1: pointer to ciphertext string
# $a2: pointer to indices array
# $a3: num_indices

# register conventions:
# $t0: current index in indices array
# $t1: current index in ciphertext string
# $t2: current index in plaintext buffer

null_cipher_sf:
    move $t0, $a2        # initialize $t0 to start of indices array
    move $t1, $a1        # initialize $t1 to start of ciphertext string
    move $t2, $a0        # initialize $t2 to start of plaintext buffer
    li $t3, 0x00		 # no of curr indices passed
    li $t4, 0x00	     # no of words skipped

# $t7 = curr indices   
# adds an offset of $t7 and then skips till a space is reached
# if string is null or max indices no is reached the loop ends
null_cipher_loop:
	bge $t3, $a3, end
	lb $t7, 0($t0)
	li $t6, 0x00
	beq $t6, $t7, skip
	add $t1, $t1, $t7
	bne $t3, $t6, next
	addi $t1, $t1, -1	
	next:
	lb $t7, 0($t1)
	sb $t7, 0($t2)
	addi $t3, $t3, 1
	addi $t0, $t0, 4
	addi $t2, $t2, 1
	j skip_loop
	    
skip:	
	addi $t0, $t0, 4
	addi $t3, $t3, 1
	addi $t4, $t4, 1
skip_loop:
	addi $t1, $t1, 1
	li $t6, ' '
	lb $t7, 0($t1)
	beq $t7, $t6, null_cipher_loop
	li $t6, '\0'
	beq $t7, $t6, end
	j skip_loop
	
end:
    sub $t3, $t3, $t4
    move $v0, $t3
    li $t7, '\0'
    sb $t7, 0($t2)
    jr $ra	
    

transposition_cipher_sf:
	move $t0, $a0	# setting t0 to start of plaintext
	move $t1, $a1	# setting t1 to start of ciphertext
	move $t2, $a2 	# setting t2 to no of rows
	move $t3, $a3 	# setting t3 to no of cols
	li $t4, 0x00	# length of the ciphertext
	mul $t4, $t3, $t2 # len = rows * col (since it will always be padded)
	
li $t6, 0x00 # outer loop counter
transposition_loop_outer:
	beq $t6, $t3, done
	li $t5, 0x00 # inner loop counter
	inner_loop:
		beq $t5, $t2, end_inner
		lb $t7 0($t1)  # load the byte from ciphertext
		sb $t7, 0($t0) # store byte in plaintext
		addi $t1, $t1, 1
		add $t0, $t0, $t3
		addi $t5, $t5, 1
		j inner_loop
	end_inner:		
	# curr index calculation
	mul $t8, $t3, $t2  #t8 = t3 x t2
	sub $t0, $t0, $t8
	addi $t0, $t0, 1
	addi $t6, $t6, 1
	j transposition_loop_outer
		
done:
	mul $t8, $t3, $t2  #t8 = t3 x t2
	sub $t0, $t0, $t3
        li $t5, 0x00		
terminate:
	li $t7, '*'
	lb $t6, 0($t0)
	beq $t7, $t6, end_trans
	beq $t5, $t8, end_trans
	addi $t0, $t0, 1
	addi $t5, $t5, 1
	j terminate
		
	end_trans:
	
	li $t7, '\0'
	sb $t7, 0($t0)	
	move $v1, $t0		
    jr $ra
    	
decrypt_sf:

	addi $sp, $sp, -8  	# allocate space for original plaintext and ra
	sw $ra, 4($sp)  
	sw $a0, 0($sp)
	mul $t7, $a3, $a2 	# t7 = rows * cols
	addi $t7, $t7, 1
	sub $sp, $sp, $t7 	# allocate enough space for decrypted trans text
	move $a0, $sp		# point a0 to the stack pointer 
	
	jal transposition_cipher_sf
	
	mul $t7, $a3, $a2 
	addi $t7, $t7, 1
	add $sp, $sp, $t7 # deallocate from stack
	
	move $a1, $a0 # move returned decrypted text to a ciphertext arg

	lw $a0, 0($sp) # restore the og plaintext

	addi $sp, $sp, 4	# deallocate the space from $a0

	lw $a2, 8($sp) # load indices
	lw $a3, 4($sp) # load no of indices

	jal null_cipher_sf
	
	
	lw $ra, 0($sp) # restore the return address for main
	addi $sp, $sp, 4 # deallocate the address for $ra
    	
    jr $ra
