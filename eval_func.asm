################################################################################
#
# Title:           Project1 uses MIPS assembly
#
# Filename:        eval_func.asm
#
# Author:          Annette McDonough
#
# Date:           2020-02-29
#
# Description:     Project 1 Evaluates a function
#
# Input:           integers
#
# Output:          integers
#
################################################################################
# Cross refrences:
#
#	$t0:  x input variable
#       $s0:  array
#	0($s0):  a value for a coef[0]
#       4($s0):  b value for a coef[1]
#	8($s0):  c value for a coef[2]
#       $t1:  to hold value of coef[a]
#	$t2:  to hold value of coef[b]
#       $t3:  to hold value of coef[c]
#
#       $t5:  to hold value of "x^2"
#       $t6:  to hold value of "a*x^2"
#       $t7:  to hold value of "b*x"
#       $t8:  to hold the value of "a*x^2 + b*x
#	$t9:  to hold output
#
##########  Data segment  ######################################################

.data
arrayN:         .space 12 # array for coefs
xInput:         .word 0 # 32 bit word input for X eval(if I get there
Quad_String:    .asciiz "\nf(x)= a*x^2 + b*x + c \n\n" # to show a quadradic 
coeff:		.asciiz "Enter coefficient [0]: " # prompt for coef's
xVal:           .asciiz "Enter input value [x]: " # prompt for x value
plus:           .asciiz " + "  # plus sign
prod:           .asciiz "*" # multiplication sign
sq:             .asciiz "x^2" # squared symbol
eq:		.asciiz " = " # equals sign
output:         .word 0  # 32 bit word for output
fx:             .asciiz "\nf(x) = " # displays f(x)
xEq:            .asciiz "\nx = "  # displays x = 
xvar:           .asciiz "x"       # displays x
posX:           .word 0 # 32 bit word for positive x value
negX:           .word 0 # 32 bit word for negative x value
four:           .float 4.0 # constant variable for quad evaluation
zero:           .float 0.0 # to compare for a negative from b^2-4ac
two:            .float 2.0 # to divide by 2 for babylonian method

##########  Code segment  ######################################################

.text

.globl main
###########################################################################################
# Function Name:   main
# Description:     programs entry point
############################################################################################
main:                           # Program entry point

       jal get_input            # jump to getValues function
    
       jal compute_f_of_x       # jump to compute f(x) function
    
       jal display_f_of_x       # jump to display f(x) function

       jal square_root          # jump to square root

       li $v0, 10               # Exit program
       syscall
 
#############################################################################################
# Function Name:   display_f_of_x
# Description:     displays the computed f(x) function 
############################################################################################## 
display_f_of_x:

	la $s0, arrayN     # initalize array parameters

	li  $v0, 4         # system code call for print string
	la  $a0, fx        # print "f(x)="
	syscall
	
	li  $v0, 1         # system code call to print integer
	lw  $a0, 0($s0)    # print coef[a]
	syscall
	
	li  $v0, 4         # system code call for print string
	la  $a0, prod      # print " * "
	syscall
	
	li  $v0, 4         # system code call for print string
	la  $a0, sq        # print "x^2"
	syscall 
	
	li  $v0, 4         # system code call for print string
	la  $a0, plus      # print " + "
	syscall
	
	li  $v0, 1         # system code call for print integer
	lw  $a0, 4($s0)    # print coef[b] input       
	syscall
	
	li  $v0, 4         # system code call for print string
	la  $a0, prod      # print " * "
	syscall
	
	li  $v0, 4         # system code call for print integer
	la  $a0, xvar      # print "x"
	syscall
	
	li  $v0, 4         # system code call for print string
	la  $a0, plus      # print " + "
	syscall
	
	li  $v0, 1         # system code call for print integer
	lw  $a0, 8($s0)    # print coef[c] input
	syscall
	
	li  $v0, 4 	   # system code call for print string#	la  $a0, g         # print ")= "
	la  $a0, eq
	syscall
	
	li  $v0, 1         # system code call for print integer
	lw  $a0, output    # print final value of equation  
	syscall            # f(x) = ax^2+bx+c= value printed

        jr  $ra            # return to main
          
 #############################################################################################
# Function Name:   compute_f_of_x
# Description:     computes f(x)
##############################################################################################
compute_f_of_x:

	la  $s0, arrayN     # initalize array parameters
	lw  $t0, xInput     # load x input into $t0
	lw  $t1, 0($s0)     # load coef[a] into $t1
	lw  $t2, 4($s0)     # load coef[b] into $t2
	lw  $t3, 8($s0)     # load coef[c] into $t3

        mult $t0, $t0       # square x value "x^2"
        mflo $t5            # store value of "x^2" in $t5
 
	mult $t1, $t5       # multiply coef[a] by results of "x^2"
        mflo $t6            # store value of "a*x^2" in $t6
        
	mult $t2, $t0       # multiply coef[b] by x value "b*x"
        mflo $t7            # store value of "b*x" in $t7
        
        add $t8, $t7, $t6   # ax^2 + bx = $t8
        add $t9, $t8, $t3   # ax^2 + bx + c = $t9
        
        sw  $t9, output     # output for f(x)
        
        jr  $ra             # return to main 
 
#############################################################################################
# Function Name:   square_root
# Description:     calculates the value of x
#############################################################################
# refrences for quad formula
# $f1 = coef[a]
# $f2 = coef[b]
# $f3 = coef[c]
#
#############################################################################################
square_root:

	la   $s0, arrayN       # initalize array parameters
	
	l.s  $f1, 0($s0)       # load coef[a] into $f1
	l.s  $f2, 4($s0)       # load coef[b] into $f2
	l.s  $f3, 8($s0)       # load coef[c] into $f3
	l.s  $f20, four        # load the float 4.0 to $f20

	mul.s $f4, $f2, $f2    # square b.$f2 * $f2 = $f4

	
	mul.s $f5, $f1, $f3    # multiply a*c ($f1 * $f3 = $f5)
	mul.s $f6, $f20, $f5   # multiply 4*(results of ac)($f20 * $f5 = $f6)
	
	sub.s $f0, $f4, $f6    # b^2-4ac ($f4 - $f6 = $f0)
	
        

#	swc1  $f0, posX        # output for x
	
	
	li  $v0, 4 	       # system code call for print string
	la  $a0, xEq           # print "x = "
	syscall
        
#       li  $v0, 1 	       # system code call for print string
#	la  $a0, posX          # print $f0 value
#	syscall
	
        li     $v0, 2          # system code call for print integer
        mov.s  $f12, $f0       # move value to be printed to $f12
        syscall                # print the result
		
        jr    $ra              # return to main 
                                                                       
#############################################################################################
# Function Name:   get_input
# Description:     gets values for array
##############################################################################################
get_input:

	li  $v0, 4            # system call code for print string
	la  $a0, Quad_String  # load quadstring into $a0
	syscall               # print f(x) = string

	la $s0, arrayN        # initalize array parameters
	li $s1, 3             # set size of array 
	li $t1, 1             # set loop counter
	
loop1:

	bgt $t1, $s1, end     # if ($t1 > $s1) branch to end 
	
	la  $a0, coeff        # load address of prompt
	add $t2, $t1, 96      # calculate ascii value
	sb  $t2, 19($a0)      # store byte in coeff[19]
	li $v0, 4
	syscall               # print prompt for coef[a]
	
	li  $v0, 5            # system code call for read integer
	syscall

	sw  $v0, ($s0)        # store value in array
	addi $s0, $s0, 4      # increment array pointer
	addi $t1, $t1, 1      # increment loop counter
	j     loop1           # jump back to loop
		

end:	
	li  $v0, 4            # system call code for print string
	la  $a0, xVal         # load address of xVal into $a0
	syscall               # print prompt for x value
	
	li  $v0, 5            # system code call for read integer
	syscall
	
	sw  $v0, xInput       # store input in x_Input
	
	jr  $ra               # return to main  
	  
