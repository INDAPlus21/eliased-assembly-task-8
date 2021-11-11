.text

main: 
	# Loads data
	lw $t0, number1 ($zero) # Is multiplied by 

	addi $t5, $zero, 1
	
	# $t0 = dynamic number that is multiplied by/taken factorial of 
	# $t1 = irrelevant when factorial, no saved max when factorial 
	# $t2 = dynamically saved max when multiplying  
	# $t3 = multiply iterator 
	# $t4 = saved copy of current max/product 
	# $t5  = factorial iterator 
	
	# Comment out if you don't want to multiply
	#lw $t1, number2 ($zero) 
	#add $t4, $zero, $t0 # Saved copy of current product 
	#jal multiply1
	
	# Comment out if you don't want to do factorial
	jal realfactorial
	
	jal exitwhile
	
realfactorial: 
	add $t1, $zero, $t0 # Define $t1 as $t0, to use it as the thing to "multiply" by, you decrease this by 1 later 
	add $t2, $zero, $t0 # Saved original. (checks if greater than in factorial loop)
	whilefactorial: 
		bgt $t5, $t2, exitwhile # Check if more than iterator. If $t5 > $t1 
		add $t4, $zero, $t0 # Saved copy of current product 
		sub $t1, $t1, 1 # Decrease how many times to multiply by 1  
		jal multiply
		addi $t5, $t5, 1 # Increase own iterator by 1
		j whilefactorial
	
multiply: 
	addi $t3, $zero, 2 # Reset iterator for multiply 
	whilemultiply: 
		bgt $t3, $t1, returntomain # Check if more than iterator 
		add $t0, $t0, $t4 # Add saved to final product 
		addi $t3, $t3, 1 # Increase own iterator by 1
		j whilemultiply

returntomain: 
	jr $ra
	
exitwhile: 
	# Prints 
	li $v0, 1
	move $a0, $t0
	syscall
	
	#li $v0,4
	#la $a0, message
	#syscall

.data
number1: .word 5
number2: .word 3
#message: .asciiz "\nWhile loop is finished" 
