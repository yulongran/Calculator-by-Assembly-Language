.include "./cs47_proj_macro.asm"
.include "./cs47_common_macro.asm"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_logical:

# au_logical:

	beq $a2, 0x2B , Addition   # ASCII for + is Hex: 2B
	beq $a2, 0x2D, Subtraction  # ASCII for - is Hex: 2D
	beq $a2, 0x2A, Multiplication  # ASCII for * is Hex: 2A
	beq $a2, 0x2F , Division  # ASCII for / is Hex: 2F
	
	
#####################################################################
#		             ADDITION		                    #
#####################################################################
# $a0: First number
# $a1: Second number
# $a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# $v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# $v1: ($a0 * $a1):HI | ($a0 % $a1)
# $s0: carry bit value for the first number
# $s1: carry bit value for the second number
# $s2: bit index
# $s3: first carry
# $s4: result bit
# $s5: maskRegister
# $s6: carry result
# $s7: Maximum bit 32
Addition:
# Caller RTE store:
	addi $sp, $sp, -60 
	sw $fp, 60($sp)
	sw $ra, 56($sp)
	sw $a0, 52($sp)
	sw $a1, 48($sp)
	sw $a2, 44($sp)
	sw $a3, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 60		
	li  $s2, 0        	   # Set bit index  i at 0
	li  $s7, 32		   # Loop run 32 times
	li  $s6, 0		   # Set starting carry at 0
	jal Addition_loop	
Addition_loop:

	extract_nth($s2, $a0, $s0)    # Extract bit value at i for first number
	extract_nth($s2, $a1, $s1)    # Extract bit value at i for second number
				      # extract_nth($regNthBit, $regInput, $regResult)
	xor $s4, $s6, $s0             #  Starting carry xor  a
	and $s3, $s6, $s0             # Carry for c and a
	and $s6, $s4,  $s1            # Second carry for (c xor a) and b
	or  $s6, $s6, $s3             # Carry result= first carry or second carry
	xor $s4, $s4, $s1             # Result bit = Result bit xor second bit
	insert_to_nth_bit ($s2, $v0, $s4, $s5)     # Insert the result back to the $V0 (result)
	addi $s2, $s2, 1		           # Increment i 
	blt $s2, $s7, Addition_loop                # i < 32 loop
	
	move $v1, $s6                        # Return final carry out in $v1 for Multiplication 
	
	j RTE_restore
	
	
	
	
#####################################################################
#		          SUBTRACTION		                    #
#####################################################################	

# $a0: First number
# $a1: Second number
# $a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# $v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# $v1: ($a0 * $a1):HI | ($a0 % $a1)
# $s0: carry bit value for the first number
# $s1: carry bit value for the second number
# $s2: bit index
# $s3: first carry
# $s4: result bit
# $s5: maskRegister
# $s6: carry result
# $s7: Maximum bit 32 
Subtraction:
	
# Caller RTE store:
	addi $sp, $sp, -60 
	sw $fp, 60($sp)
	sw $ra, 56($sp)
	sw $a0, 52($sp)
	sw $a1, 48($sp)
	sw $a2, 44($sp)
	sw $a3, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 60		
	li  $s2, 0        	   # Set bit index  i at 0
	li  $s7, 32		   # Loop run 32 times
	li  $s6, 1		   # Set starting carry to 1 for subtraction

	not $a1, $a1
	jal Subtraction_loop
	
Subtraction_loop:
	
	extract_nth($s2, $a0, $s0)   # Extract bit value at i for first number
	extract_nth($s2, $a1, $s1)   # Extract bit value at i for second number
				     # extract_nth($regNthBit, $regInput, $regResult)
	xor $s4, $s6, $s0            # Carry xor  a
	and $s3, $s6, $s0            # Carry for c and a
	and $s6, $s4,  $s1           # Second carry for (c xor a) and b
	or  $s6, $s6, $s3	     # Carry result= first carry or second carry
	xor $s4, $s4, $s1            # Result bit = Result bit xor second bit
	insert_to_nth_bit ($s2, $v0, $s4, $s5)     # Insert the result back to the $V0 (result)
	addi $s2, $s2, 1		           # Increment i 
	blt $s2, $s7, Subtraction_loop             # i<32, loop
	j RTE_restore

 
  
#####################################################################
#		         Multiplication		                    #
##################################################################### 
Multiplication:
# Caller RTE store:
	addi $sp, $sp, -60 
	sw $fp, 60($sp)
	sw $ra, 56($sp)
	sw $a0, 52($sp)
	sw $a1, 48($sp)
	sw $a2, 44($sp)
	sw $a3, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 60
	
	li  $s2, 0        	   # Set bit index  i at 0
	li  $s7, 32		   # Loop run 32 times
	jal Signed_Multiplication
	j RTE_restore

# Compute two's complement of $a0; return two's complement of $a0 at $v0
twos_complement:
# Caller RTE store:
	addi $sp, $sp, -60 
	sw $fp, 60($sp)
	sw $ra, 56($sp)
	sw $a0, 52($sp)
	sw $a1, 48($sp)
	sw $a2, 44($sp)
	sw $a3, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 60
	
# $a1 hold value of 1
	li $a1, 1       
	not $a0, $a0    # Not $a0
	jal Addition    # ~$a1+1 = two's complement
	j RTE_restore

# Compute two's complement of $a0; return two's complement of $a0 at $v0	
twos_complement_if_neg:

# Caller RTE store:
	addi $sp, $sp, -60 
	sw $fp, 60($sp)
	sw $ra, 56($sp)
	sw $a0, 52($sp)
	sw $a1, 48($sp)
	sw $a2, 44($sp)
	sw $a3, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 60
	
	bge $a0, 0, remain_same     # Postive number, remain same
	jal twos_complement         # Negative go to two's complement
	j RTE_restore
	
remain_same:
	addi $v0, $a0, 0           # value at a0 remain same but move to $v0
	j RTE_restore
	
			
# $a0 Lo of the number | $a1 Hi of the number
# $v0 Lo part of 2's complemented 64 bit | $v1 Hi part of 2's complemented 64 bit
twos_complement_64bit:
# Caller RTE store:
	addi $sp, $sp, -60 
	sw $fp, 60($sp)
	sw $ra, 56($sp)
	sw $a0, 52($sp)
	sw $a1, 48($sp)
	sw $a2, 44($sp)
	sw $a3, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 60
	
	# Invert both $a0, $a1
	not $a0, $a0     
	not $a1, $a1  
	
	 #Use add_logical to add 1 to $a0
	move $t6, $a1    # Store second number $a1 to $t1
	li  $a1, 1
	jal Addition            #  Addition with $a0 and $a1 (1)
	move $t2, $v0           # Store Lo part of 2's in to t2
	move $a0, $t6    # Move original $a1 value back
	move $a1, $v1    # Set second number to the value of the carry
	jal Addition            # Addition of carry with $a1\
	move $v1, $v0	# Store High part 2's in $v1
	move $v0, $t2    # Store Lo part 2's in $v0
	j RTE_restore
	
# Return $v0 of value 0x000000000 if $a0 =0x0; value FFFFFFFF if $a0 = 0x1
bit_replicator:
	
# Caller RTE store:
	addi $sp, $sp, -60 
	sw $fp, 60($sp)
	sw $ra, 56($sp)
	sw $a0, 52($sp)
	sw $a1, 48($sp)
	sw $a2, 44($sp)
	sw $a3, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 60
	
	
	ble $a0, $zero, Assign_zero        # If a0 =0x0; assign v0=0x00000000
	bgt $a0, $zero, Assign_one         # If a0 =0x1; assign v0=0xffffffff
	j RTE_restore
	
Assign_zero:
	add $v0, $zero, 0x00000000
	j RTE_restore
Assign_one:
	add $v0, $zero, 0xffffffff
	j RTE_restore

 
# $a0: First number
# $a1: Second number
# $a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# $v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# $v1: ($a0 * $a1):HI | ($a0 % $a1)
# $s0:  L[0]
# $s1:  copy of MPLR / L
# $s2: bit index
# $s3: R
# $s4: X
# $s5: maskRegister / copy of MCND / M
# $s6: r
# $s7: 32 times
# $t1, Hold value of 31
# $t2, Hold value of H[0]
# $t3, Mask Register for insert_to_nth_bit
# $t4, H

Unsigned_Multiplication:
# Caller RTE store:
	addi $sp, $sp, -60 
	sw $fp, 60($sp)
	sw $ra, 56($sp)
	sw $a0, 52($sp)
	sw $a1, 48($sp)
	sw $a2, 44($sp)
	sw $a3, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 60

	li $s2,0
	li $t4, 0               # H=0 at beginning
	li $t1, 31              # Hold value of 31 for getting 31th bit
	move $s1, $a1     # L= second number
	move $s5, $a0     # M = first number
	
 	jal  Unsigned_Multiplication_loop
 	
 	j RTE_restore
 	
 	
Unsigned_Multiplication_loop:

 	extract_nth($zero,$s1, $a0)     # extract_nth($regNthBit, $regInput, $regResult)
 	jal bit_replicator
 	move $s3, $v0             # Move result of bit replicator to R
 	and $s4, $s5, $s3               # X= M & R
 	
 	
 	move $a0, $t4     	# Move H to $a0 for addition
 	move $a1, $s4    		# Move x to $a1 for adition
 	jal Addition	     		# Addition
 	move $t4, $v0      	# H = H+x
 	srl  $s1, $s1, 1      		# L= L>>1
 	extract_nth($zero, $t4, $t2)    # extract_nth($regNthBit, $regInput, $regResult)
 	insert_to_nth_bit($t1, $s1  ,$t2, $t5)  #insert_to_nth_bit ($regNthBit, $regInput, $regValue, $maskRegister)
 	
 	srl $t4, $t4, 1			# H= H>>1
 	addi $s2, $s2, 1        	# Increment i 
 	
 	blt  $s2, $s7, Unsigned_Multiplication_loop
 	
 	
 	move $v0, $s1        	# End result of Lo
 	move $v1, $t4        	# End result of H
 	j RTE_restore
 	
 
# $a0: First number
# $a1: Second number
# $a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# $v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# $v1: ($a0 * $a1):HI | ($a0 % $a1)
# $s0: copy of MPLR
# $s1: N2
# $s2: bit index
# $s3: R
# $s4: X
# $s5: N1
# $s6: r
# $s7: H
# $t1, Hold value of 31
# $t2, Hold value of L[31]
# $t3, Mask Register for insert_to_nth_bit
# $t4, $a0[31]
# $t5, $a1[31]
# $t6, S
# $t7, 1

Signed_Multiplication:
 
 	# Caller RTE store:
	addi $sp, $sp, -60 
	sw $fp, 60($sp)
	sw $ra, 56($sp)
	sw $a0, 52($sp)
	sw $a1, 48($sp)
	sw $a2, 44($sp)
	sw $a3, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 60
	
	
	li $t1, 31
	
	extract_nth($t1, $a0, $t4) # extract_nth($regNthBit, $regInput, $regResult)
 	extract_nth($t1, $a1, $t5)
 	 
 	move $s5, $a0            # N1= $a0
 	move $s1, $a1    	 # N2= $a1
 	move $a0, $s5		 # Move N1 to $a0 for two's complement caller
 	jal twos_complement_if_neg
 	move $s5, $v0     # N1= $V0
 	move $a0, $s1     # Move N2 to $a0 for two's complement caller
 	jal twos_complement_if_neg  # Move N2 to $a0 for two's complement caller
 	move $s1, $v0    # Move two's complement back to $s1
 	move $a0, $s5   # Move N1 to $a0, for Unsigned_Mul
 	move $a1, $s1    # Move N2 to $a0, for Unsigned_Mul
 	xor $t6, $t4, $t5
 	jal Unsigned_Multiplication
 	
 	
 	move $a0, $v0      # For twos_complement_64 bit
 	move $a1, $v1      # For twos_complement_64 bit
 	
 	bgt $t6, $zero, twos_complement_64bit
 	#jal  twos_complement_64bit #twos_complement_64bit
 	j RTE_restore
 
 
 
#####################################################################
#		           DIVISION		                    #
#####################################################################	
Division:

	# Caller RTE store:
	addi $sp, $sp, -60 
	sw $fp, 60($sp)
	sw $ra, 56($sp)
	sw $a0, 52($sp)
	sw $a1, 48($sp)
	sw $a2, 44($sp)
	sw $a3, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 60
	
	
	li $s2, 0                   # Bit index i =0
	li $s7, 32
		
	jal Signed_Dvision		   		   
	j RTE_restore



# $a0: First number
# $a1: Second number
# $a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# $v0: Quotient
# $v1: Remainder
# $s0: Q = DVND
# $s1: D = DVSR
# $s2: bit index
# $s3: R
# $s4: Hold Value of 31
# $s5: S
# $s6: maskRegister for insert bit
# $s7: Maximum bit 32
# $t0: bit value at $v1 after mul
# $t2: Hold value of 1
# $t3: MaskRegister for Q[0]=1
# $t4: Q[31]
div_unsigned:

# Caller RTE store:
	addi $sp, $sp, -60 
	sw $fp, 60($sp)
	sw $ra, 56($sp)
	sw $a0, 52($sp)
	sw $a1, 48($sp)
	sw $a2, 44($sp)
	sw $a3, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 60
	
	move $s0, $a0               # Q= DVND
	move $s1, $a1               # D= DVSR
	li $s3, 0                   # R=0
	li $s6, 0		    # Empty the mask register
	li $s5, 0
	li $t0, 0
	li $t2, 0		    # Empty the temporary register
	li $t3, 0		    # Empty the mask register
	li $t4, 0		    # Q[31], empty the temporary register
	jal div_unsigned_loop
	j RTE_restore
	

div_unsigned_loop:
	sll  $s3, $s3, 1            # R= R<<1
	li $s4, 31		    # 31 Value for extract 31th bit
	extract_nth($s4,$s0,$t4)   # extract_nth($regNthBit, $regInput, $regResult)
	insert_to_nth_bit($zero, $s3, $t4,$s6)	    #insert_to_nth_bit ($regNthBit, $regInput, $regValue, $maskRegister)
	sll $s0, $s0, 1             # Q=Q <<1
	move $a0, $s3               # Move R to $a0 for sub
	move $a1, $s1		    # Move D to $a1 for sub
	jal Subtraction
	move $s5, $v0              # Set S to the sub result
	
	blt $s5, $zero, increment_i
	#addi $s2, $s2, 1            # Increment i
	#blt  $s2, $s7, div_unsigned_loop      # i== 32?
	move $s3, $s5              # R=s
	li $t2, 1
	insert_to_nth_bit($zero, $s0, $t2,$t3)	    #insert_to_nth_bit ($regNthBit, $regInput, $regValue, $maskRegister)
	
	#jal increment_i
	
increment_i:

	addi $s2, $s2, 1            # Increment i
	bne    $s2, $s7, div_unsigned_loop      # i== 32?
	move $v0, $s0
	move $v1, $s3
	j RTE_restore


# $a0: First number
# $a1: Second number
# $a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# $v0: Quotient
# $v1: Remainder
# $s0: N1 = DVND
# $s1: N2 = DVSR
# $s2: bit index
# $s3: R
# $s4: Hold Value of 31
# $s5: a0[31]
# $s6: a1[31]
# $s7: Maximum bit 32
# $t0: a0[31]
# $t2: a1[31]
# $t3: MaskRegister for Q[0]=1
# $t4: a0[31]
# $t5: Q
# $t6: R
# $t7: S
Signed_Dvision:

	# Caller RTE store:
	addi $sp, $sp, -60 
	sw $fp, 60($sp)
	sw $ra, 56($sp)
	sw $a0, 52($sp)
	sw $a1, 48($sp)
	sw $a2, 44($sp)
	sw $a3, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp, 60
	
	
	li $s4, 31          # Hold value of 31
	extract_nth($s4,$a0, $s5)   # extract_nth($regNthBit, $regInput, $regResult)
	extract_nth($s4,$a1, $s6)   # extract_nth($regNthBit, $regInput, $regResult)
	move $s0, $a0       # N1= $a0
	move $s1, $a1	    # N2= $a1
	move $a0, $s0       # Move N1 to $a0 for two's complement caller
 	jal twos_complement_if_neg
 	move $s0, $v0        # N1= $v0
 	move $a0, $s1	     # Move N2 to $a0 for two's complement caller
 	jal twos_complement_if_neg
 	move $s1, $v0	     # N1= $v0
 	
 	move $a0, $s0	    # Move N1 to $a0 for unsigned div caller 
 	move $a1, $s1       # Move N2 to $a1 for unsigned div caller
 	
 	xor $t7, $s5, $s6    # Sign of X
 	
 	jal div_unsigned
 	move $t1, $v0       # Q= $v0
 	move $t6, $v1       # R= $v1
 
 	
 	# Determine sign of Q and R
 	jal Change_sign
 	j RTE_restore
 
# Change sign of R	
Change_sign:
	beq $s5, $zero, Change_sign_Q    # a[31] is zero, dont change R, else change Q to twos_complement
	move $a0, $t6
	jal twos_complement
	move $t6, $v0
	jal Change_sign_Q

# Change sign of Q	
Change_sign_Q:
	
	beq $t7, $zero, finished         # S is zero, finished
	move $a0, $t1
	jal  twos_complement
	move $t1, $v0
	jal finished
	
finished:
	move $v0, $t1			# Move Q to v0
 	move $v1, $t6
	j RTE_restore			# Moce R to v1
		

# Caller RTE restore

RTE_restore:

	lw $fp, 60($sp)
	lw $ra, 56($sp)
	lw $a0, 52($sp)
	lw $a1, 48($sp)
	lw $a2, 44($sp)
	lw $a3, 40($sp)
	lw $s0, 36($sp)
	lw $s1, 32($sp)
	lw $s2, 28($sp)
	lw $s3, 24($sp)
	lw $s4, 20($sp)
	lw $s5, 16($sp)
	lw $s6, 12($sp)
	lw $s7, 8($sp)
	addi $sp, $sp, 60
	jr 	$ra
