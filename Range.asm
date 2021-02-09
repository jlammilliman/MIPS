# File name:	Range.asm
# Author:		Justin Milliman  - jlmillim@mtu.edu
# Purpose: 		This program takes in two numbers,
#				N, and M. It prints out the range
#				between N and M in ascending and
#				decending order. If N is greater 
#				than M, the program terminates. 
# 
# Programming at the Hardware/Software Interface
# CS 1142 - R01
# Date Last Modified: 1/21/2021
# =================================================
# Pseudo Code
# main
# {
#	get user imput -> N
#	get user input -> M
# 	while ( N < M ){
#		print N;
#		N++;
#	}
# 	while ( M > N ){
#		print M;
#		M--;
#	}
# }
#==================================================
# Example Input -> {N = -1, M = 6}
# Output:
#			-1 0 1 2 3 4 5 6
#			 6 5 4 3 2 1 0 -1
#==================================================
main:
	# first number [N] [$t0, $t2]
	li 		$v0, 5
	syscall
	move 	$t0, $v0
	move 	$t2, $t0 # make a copy of N [$t0] for decending loop
	# second number [M] [$t1]
	li 		$v0, 5
	syscall
	move 	$t1, $v0


	# If N [$t0] is greater than M [$t1], terminate
	bgt 	$t0, $t1, done


	loopAscend:
		# If we are <= M, print the value, increment by +1
		move 	$a0, $t0 # Set $a0 to the value of N	
		li		$v0, 1
		syscall			 # print $a0
		# Print a space 
    	li         $v0, 11       # syscall 11 prints chracter stored in $a0 
    	addi       $a0, $0, 32   # ASCII code 32 is a space
    	syscall 
		# Increment: N + 1, if N + 1 is less than or equal to M, loop again 
		addi 	$t0, $t0, 1 # increment N by +1
		ble 	$t0, $t1, loopAscend


	# Create a new Line
    li 	      $v0, 11 	     # syscall 11 prints chracter stored in $a0
    addi      $a0, $0, 10    # ASCII code 10 is a line feed
    syscall


	loopDecend:
		# If we are >= N, print the value, increment by -1
		move 	$a0, $t1 # Set $a0 to the value of M	
		li		$v0, 1
		syscall			 # print $a0
		# Print a space 
    	li         $v0, 11       # syscall 11 prints chracter stored in $a0 
    	addi       $a0, $0, 32   # ASCII code 32 is a space
    	syscall 
		# Increment: M - 1, if M - 1 is greater than or equal to N, loop again 
		addi 	$t1, $t1, -1 # increment M by -1
		bge 	$t1, $t2, loopDecend # use copied N [$t2] from above
#===========================================================================
done: # comtrya!
