#lelab05.asm  
#Author: Trung Le
#Date:	03/11/15
#Proj: A MIPs procedure to print out the fibonacci sequence
	.text
	.globl main

#Purpose: Main driver
#Input: Reads integer n from user
#Output: Displays nth value of fibonacci sequence
main:
	addi 	$sp,$sp,-16 #save in stack
	sw 	$ra,0($sp)
	sw 	$s0,4($sp)
	sw 	$s1,8($sp)
	sw	$fp, 12($sp)
	add	$fp, $sp, 12
	
	la	$a0, greet		#print greeting
	li	$v0, 4
	syscall	

loop:	la	$a0, prompt		#prompt user for integer
	li	$v0, 4
	syscall
	
	li	$v0, 5			#read integer from user
	syscall	
	
	move	$a0, $v0		#store user input into $a0
	add	$t3, $a0, $0		#temp store $a0 in temp 2
	
	add	$t0, $0, $0		#store 0 in $t0
	addi	$t2, $t0, 1
	slt	$t1, $a0, $t0		#if $a0 < 0 then $t1 = 1
	
	beq	$t1, $t2, done		#if $t1 = 1 then $a0 < 0 then jump to done	
	
	jal	fib
	add	$t0, $v0, $0		#store result in $t0

	la	$a0, msg		#print result
	li	$v0, 4
	syscall
	move	$a0, $t3
	li	$v0, 1
	syscall
	la	$a0, msg2
	li	$v0, 4
	syscall
	move	$a0, $t0
	li	$v0, 1
	syscall
	
	j	loop			#loop
		
done:	la	$a0, end
	li	$v0, 4
	syscall

	lw 	$ra,0($sp)		#reallocate memory
	lw 	$s0,4($sp)
	lw 	$s1,8($sp)
	lw	$fp, 12($sp)	
	addi	$sp, $sp, 12		#pop stack pointer
	
	jr	$ra


#Purpose: Calculate the nth value of the fibonacci sequence
#Input: Integer
#Output: returns nth value of fibonacci sequence
fib:	
	addi 	$sp,$sp,-12 		#allocate memory
	sw 	$ra,0($sp)		
	sw 	$s0,4($sp)	
	sw 	$s1,8($sp)

	add 	$s0,$a0,$zero	 	#store $a0 in $s0

	addi 	$t1,$0, 1		#store 1 in $t1 for base case comparison
	beq 	$s0, $0, case0		#if n == 0, jump to case0
	beq 	$s0, $t1, case1		#if n == 1, jump to case1

	addi 	$a0,$s0,-1		#$a0 = n-1

	jal 	fib			#call fib with arguments fib(n-1)

	add 	$s1,$zero,$v0    	#s1=fib(n-1)

	addi 	$a0,$s0,-2		#a0 = n-2

	jal 	fib               	#call fib with arguments fib(n-2)

	add 	$v0,$v0,$s1      	#v0 = fib(n-2) + fib(n-1)


exit:	lw 	$ra,0($sp)      	#read registers from stack
	lw 	$s0,4($sp)
	lw 	$s1,8($sp)
	addi 	$sp,$sp,12     	  	#pop stack pointer
	jr 	$ra


case1: 	li 	$v0,1			#return 1
 	j 	exit

case0:  li 	$v0,0			#return 0
 	j 	exit



	.data
greet:	.asciiz "This MIPs program calculates the nth value of the fibonacci sequence"
prompt:	.asciiz "\n\nPlease enter an integer: "
msg:	.asciiz "fibonacci("
msg2:	.asciiz ") = "
end:	.asciiz "\nDone"


#c++ code used
#int fibonacci(int n)
#{   
#
#    if (n == 0)
#    {
#        return 0;
#    }   
#    else if (n == 1)
#    {
#        return 1;
#    }
#    else
#    {
#        return fibonacci(n-1) + fibonacci(n-2);
#    }
#
#}



