# File name:	Grid.asm
# Author:		Justin Milliman  - jlmillim@mtu.edu
# Purpose: 		Creates an alternating grid pattern
# 				of 1's and 0's.
# 
# Programming at the Hardware/Software Interface
# CS 1142 - R01
# Date Last Modified: 1/21/2021
# =================================================
# Pseudo Code
# main
# {
#	get user imput for number of rows -> N
#	get user input for number of columns -> M
# 	if ( N <= 0 || M <= 0 ) -> Terminate
#	for ( int i = N; i > 0; i-- ){
#		for ( int j = M; j > 0; j-- ){
#			if( currentR row and/or current column is an edge ) {
#				print a 1;
#			} else {
#				if ( currentRowIndex + currentColumnIndex / 2 == 0 remainder ) { 
#					print 0; 
#				} else { print 1; }
#			}
# 		}
#	}
# }
#==================================================
# Example Input -> {N = 4, M = 6}
# Output:
#		1 1 1 1 1 1
#		1 0 1 0 1 1
#		1 1 0 1 0 1
#		1 1 1 1 1 1
#==================================================

	li 		$t6, 1 # Useful because I use the integer 1 a lot


	# first number [N -> $t0]
	li 		$v0, 5
	syscall
	move 	$t0, $v0
	
	# second number [M -> $t1]
	li 		$v0, 5
	syscall
	move 	$t1, $v0
	

	# Check for valid input [N > 0; M > 0]
	ble 	$t0, $0, done # If [N >= 1] -> terminate
	ble 	$t1, $0, done # If [M >= 1] -> terminate
	# Some funky, no matter what I do, it will not accept user input
	
	# Set our trusty position tracker [currentRowIndex] to N
	move	$t2, $t0

	# Begin OuterLoop
	outerLoop:

	# Set our trusty position tracker [currentColumnIndex] "back" to M
	move	$t3, $t1
	
	

	# Begin InnerLoop -- This is where most of the magic happens
	innerLoop:

	# Determine if we are on an edge of the grid 
	# Edge Case 1: if currentRowIndex    = 1 -> edge
	beq		$t2, $t6, isEdge
	# Edge Case 2: if currentColumnIndex = 1 -> edge
	beq		$t3, $t6, isEdge
	# Edge Case 3: if currentRowIndex    = N -> edge
	beq		$t2, $t0, isEdge
	# Edge Case 4: if currentColumnIndex = M -> edge
	beq		$t3, $t1, isEdge
	b 		notEdge # If you get here naturally, its not an edge 
	
	isEdge:
	# If you have an edge, set the currentBit to be 1 and move to gotBit because you have got a bit :D
	move	$t4, $t6
	b 		gotBit # Skip the rest of the bit logic
	notEdge:

	# Determine if [(currentRowIndex + currentColumnIndex) / 2 = 0] | [If = 0, print 0] [If != 0, print 1]
	add		$t5, $t3, $t2   # [currentRowIndex + currentColumnIndex]
	li		$t4, 2		    # [$t4 -> 2]
	div		$t5, $t4	    # [(currentRowIndex + currentColumnIndex) / 2]
	mfhi	$t4			    # [$t4 -> remainder]
	beq		$t4, $0, gotBit # If it is already zero, leave it alone
	move	$t4, $t6	    # [$t4 -> 1]
	gotBit:

	# Print the current Bit
	move 	$a0, $t4 # Set $a0 to the currentBit	
	li		$v0, 1
	syscall			 # print $a0

	# Increment the currentColumnIndex or else, then restart the inner loop
	add		$t3, $t3, -1
	bgt		$t3, $0, innerLoop
	
	

	# Create a new Line
    li 	    $v0, 11 	   # syscall 11 prints chracter stored in $a0
    addi   	$a0, $0, 10    # ASCII code 10 is a line feed
    syscall
    
	# Increment the current Row we are working on and restart the outer loop
	add		$t2, $t2, -1
	bgt		$t2, $0, outerLoop
	
	

	done: # Comtrya!
