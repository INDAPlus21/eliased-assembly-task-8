.text
.globl factorial
.globl multiply

# Push value to application stack.
.macro	PUSH (%reg)
	addi	$sp,$sp,-4              # decrement stack pointer (stack builds "downwards" in memory)
	sw	    %reg,0($sp)         # save value to stack
.end_macro

# Pop value from application stack.
.macro	POP (%reg)
	lw	    %reg,0($sp)  # load value from stack to given registry
	addi	$sp,$sp,4        # increment stack pointer (stack builds "downwards" in memory)
.end_macro

main: 
	# Loads data
	lw $a0, number1 ($zero) # Is multiplied by 
	
	# $a0 = dynamic number that is multiplied by/taken factorial of 
	# $a1 = irrelevant when factorial, other number to multiplied  
	# $t1 = dynamically saved max when multiplying  
	# $t2 = multiply iterator 
	# $t3 = saved copy of current max/product 
	# $t4  = factorial iterator 
	
	# Comment out if you don't want to multiply
	#lw $a1, number2 ($zero) 
	# jal multiply
	
	# Comment out if you don't want to do factorial
	jal factorial
	
	jal exit_while

# takes in $a0, returns $v1 
factorial: 
	PUSH($ra)
	addi $t4, $zero, 1 # factorial iterator 
	move $t0, $a0 # Define $t0 as $a0, to use it as the thing to "multiply" by, you decrease this by 1 later 
	move $t1, $a0 # Saved original. (checks if greater than in factorial loop)
	move $v1, $a0 # set second argument to total value     
	while_factorial: 
		beq $t4, $t1, exit_factorial # Check if more than iterator. If $t4 > $t1
		sub $t0, $t0, 1 # Decrease how many times to multiply by 1  
		move $a0, $t0 # set first argument to how many times 
		move $a1, $v1 # set second argument to total value     
		jal multiply
		move $v1, $v0 # set total value to return value
		addi $t4, $t4, 1 # Increase own iterator by 1
		j while_factorial
	exit_factorial: 
		POP($ra)
		jr $ra # returns to caller 

# takes in $a0 & $a1, returns $v0 
multiply: 
	PUSH($ra)
	addi $t2, $zero, 2 # Reset iterator for multiply 
	move $v0, $a0 # Save value of the argument in $v0, to return
	move $t3, $a0 # Saved copy of initial argument  
	while_multiply: 
		bgt $t2, $a1, exit_multiply # Check if more than iterator 
		add $v0, $v0, $t3 # Add saved to final product 
		addi $t2, $t2, 1 # Increase own iterator by 1
		j while_multiply
	exit_multiply: 
		POP($ra)
		jr $ra # returns to caller 
	
exit_while: 	
	move $a0, $v1 # prints factorial. change to $v0 to print multiply 
	li $v0, 1
	syscall

.data
number1: .word 5
number2: .word 5
