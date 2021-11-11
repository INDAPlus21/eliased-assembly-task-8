### Data Declaration Section ###

.data

primes:	.space  1000            # reserves a block of 1000 bytes in application memory
err_msg: .asciiz "Invalid input! Expected integer n, where 1 < n < 1001.\n"
newline: 	.asciiz "\n"

### Executable Code Section ###

.text
main:
    	# get input
    	li $v0, 5                   # set system call code to "read integer"
    	syscall                         # read integer from standard input stream to $v0

    	# validate input
    	li $t0, 1001
    	slt $t1, $v0, $t0		        # $t1 = input < 1001
    	beq $t1, $zero, invalid_input # if !(input < 1001), jump to invalid_input
    	nop
    	li $t0, 1
    	slt $t1, $t0, $v0		        # $t1 = 1 < input
    	beq $t1, $zero, invalid_input # if !(1 < input), jump to invalid_input
    	nop
    
    	# initialise primes array
    	la $t0, primes              # address of the first element in the array
    	sub $t1, $v0, 1 # stores input sub as to not include one number above input 
    	li $t2, 0
    	li $t3, 1
    	
    	# Load new line 
    	la	    $t5,newline 
	
	init_loop:
    		sb $t3, ($t0)              # primes[i] = 1
    		addi $t0, $t0, 1             # increment pointer
    		addi $t2, $t2, 1             # increment counter
    		bne $t2, $t1, init_loop     # loop if counter != 999
 
	sub $t4, $zero, 1 # counter

	# $t0 is always the prime array 
	# $t1 is the maximum value from user (and has replaced $t6 -- irrelevant for you, reader) 
	# $t2 is the "current number that is checked" in the sieve 
	# $t3 is the counter for the inner loop 
	# $t4 is the incrementor (both for main and print) 
	
	main_loop:
		bgt $t4, $t1, rest_of_program 		
		add $t4, $t4, 1 
		la $t0, primes 
		add $t0, $t0, $t4 # start nested_loop from current index/incrementor
		add $t2, $t4, 2 # it's not incremented by 2, it's defined by the incrementor + 2. 
		# That's why you can't start from 0 nor 1, because all numbers would be marked as composite 
		
		move $t3, $t4 # counter secondary loop

		nested_loop:	
			add $t0, $t0, $t2 # pointer is increased by the current number
			add $t3, $t3, $t2 # counter is increased by current number 
			
			bgt $t3, $t1, main_loop # branch if counter is greater than input value
			
			sb $zero, ($t0) # make the pointer's value not prime 
			
			j nested_loop

	rest_of_program:

    	# print code
    	la $t0, primes # pointer
    	sub $t0, $t0, 1
    	sub $t4, $zero, 1 # counter
    	
    	print_loop: 		
    		add $t0, $t0, 1
    		add $t4, $t4, 1
    		bgt $t4, $t1, exit_program 
    		lb $t3, ($t0)
    		bne $t3, $zero, print_if_prime 
    		j print_loop # continue

print_if_prime:
	add $a0, $t4, 2 # it's not incremented by 2, it's defined by the incrementor + 2. 
	li $v0, 1 
	syscall
	
	jal print_newline
	
	j print_loop
	
print_newline: 
        # Print newline
        li $v0, 4
        la $a0, ($t5)
        syscall
        jr $ra
	
invalid_input:
    	# print error message
    	li $v0, 4                  # set system call code "print string"
    	la $a0, err_msg            # load address of string err_msg into the system call argument registry
    	syscall                         # print the message to standard output stream

exit_program:
    	# exit program
    	li $v0, 10                      # set system call code to "terminate program"
    	syscall                         # exit program
