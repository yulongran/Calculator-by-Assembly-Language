# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#


# Get nth bit of the register
# regResult:  contain 0x0 or 0x1 depending on nth bit being 0 or 1
# regNthBit: Bit position
# regInput: Source bit pattern
.macro extract_nth($regNthBit, $regInput, $regResult)
	
	addi $regResult, $zero, 1  # Set result to 1 for AND logic operation
	sllv $regResult, $regResult, $regNthBit # Left shift regInput by regNthBit of bit
	and $regResult, $regInput, $regResult  # Bitwise AND for the result and input ; save Bitwise AND result into regResult
	srlv $regResult, $regResult, $regNthBit	
.end_macro 




# Insert bit 1 or 0 at nth bit to a bit pattern
# regValue: contain 0x0 or 0x1 depending on nth bit being 0 or 1
# regNthBit: position of the bit that we want to get
# regInput: Source register
# maskRegister: copy of the input
.macro insert_to_nth_bit ($regNthBit, $regInput, $regValue, $maskRegister)

	li   $maskRegister , 1     # Set maskRegister to value of 1
	sllv $maskRegister, $maskRegister, $regNthBit   # Left shift nth bit to match with the input
	not  $maskRegister, $maskRegister     # Invert maskRegister
	and  $regInput, $maskRegister, $regInput		# the number AND mask
	sllv $regValue, $regValue, $regNthBit		# Left shift the mask by n bit
	or   $regInput, $regValue, $regInput	# insert value to nth bit
	.end_macro

