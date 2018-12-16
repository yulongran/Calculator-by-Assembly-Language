.include "./cs47_proj_macro.asm"
.text
.globl au_normal
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_normal
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_normal:
	
# Caller RTE store:
	addi $sp, $sp, -24
	sw $fp, 24($sp)
	sw $ra, 20($sp)
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8 ($sp)
	addi $fp, $sp, 24
	
# au_normal:
	beq $a2, 0x2B , Addition
	beq $a2, 0x2D, Subtraction
	beq $a2, 0x2A, Multiplication
	beq $a2, 0x2F , Division

Addition:
	add $v0, $a0, $a1  # Add first number+ second number, store result to v0
	j RTE_restore
	 
Subtraction:
	sub $v0 $a0, $a1  # Sub first number- second number, store result to v0	
	j RTE_restore
	
Multiplication:
	mul $v0, $a0, $a1  # Mul first number * second number, store result to v0
	mfhi $v1           # $v1 will contains HI
	j RTE_restore
	
Division:
	div $a0, $a1  # Div first number / second number, store result to v0
	mflo $v0
	mfhi $v1		   # $v1 will contains LO
	j RTE_restore


# Caller RTE restore

RTE_restore:
	lw $fp, 24($sp)
	lw $ra, 20($sp)
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8 ($sp)
	addi $fp, $sp, 24
	
# TBD: Complete it
	jr	$ra
