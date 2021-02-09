#    File :	 Compress.asm
# @author :  Justin Milliman - jlmillim
#   Email :	 jlmillim@mtu.edu
#    Date :	 2/2/2021
# CS 1142 :  Programming at the Hardware Software Interface - R01
###############################################
# The following program reads a string of consecutive characters, terminating at null or zero charcters
# The program will then count similar chars, and rewrite in a compressed format
#
# Example Input : 		"AAABAABA"
# Compressed Output :	A3 B1 A2 B1 A1 
###############################################
.text
######### Load "Variables" #########
	li		$t0, 0		# currentStringCharIndex
	lbu		$t1, str	# previousChar, start at the first char
	li		$t2, 0		# packedMemoryOffset
	li		$t3, 0		# packedLength 
	li		$t6, 0		# currentCharCount
	li		$t7, 255			
	
######### Begin happy time #########
	beqz	$t1, toTheVoidOfDespair		# If she null, send to the void
	
######### If she not null, loop through each sequential char in the list #########
beginAnAdventure:
	lbu		$t4, str($t0)				# Grab next char, if its null, begin death process
	beq		$t4, $t1, justIncrementCount
	
getInThere:
######### If the currentChar is not the same as the previous char, pack the previous up and reset #########
	sb		$t1, packed($t2)			# Store in packed + offset
	addi	$t2, $t2, 1
	sb		$t6, packed($t2)

	addi	$t2, $t2, 1					# Update offset
	addi	$t3, $t3, 2					# Update Length
	sw		$t3, packedLen		
	
######### Reset the count and switch focus #########
	li		$t6, 0				
	move 	$t1, $t4			
	beqz 	$t4, toTheVoidOfDespair
	
######### If the next guy is not null, fall through, count will be set back to one, and all is right with the world #########
justIncrementCount:
	addi	$t0, $t0, 1
	addi	$t6, $t6, 1
	bge		$t6, $t7, getInThere		# If she >= 255, pack and restart
	b 		beginAnAdventure
	
toTheVoidOfDespair:



# Here is a kitty for making it this far, let me know if you like! :D
#				  |\_/|       
#				 / @ @ \      
#				( > º < )     
#				 `>>x<<´      
#				 /  O  \







##############################################################################
# DO NOT modify the following .text segment
# Your code should branch to this code once you have compressed str into
# packed and set the value of packedLen.
.text

finalOutput:
	li		$v0, 4					# Print out the input string str
	la		$a0, ORIG_TEXT
	syscall
	la		$a0, str
	syscall

	la		$a0, ORIG_LEN			# Print out the length of input string
	syscall

	li		$a0, 0					# Initialize index into str
finalLoop:							# Loop until null terminator to calculate length of str
	lbu		$t1, str($a0)			# Load character from str
	beqz	$t1, finalAfter			# Check for null terminator
	addi	$a0, $a0, 1				# Increment index
	b		finalLoop

finalAfter:
	li		$v0, 1					# Print the integer length
	syscall

	li		$v0, 4					# Print text representation of packed data
	la		$a0, PACKED_PAIRS
	syscall
	li		$t0, 0
	lw		$t1, packedLen


finalLoop2:							# Loop over all the pairs in the packed data
	beq		$t0, $t1, finalAfter2	# Stop when we reach end of packed
	lbu		$a0, packed($t0)		# Load a character from packed
	li		$v0, 11					# Print a character
	syscall
	addi	$t0, $t0, 1

	lbu		$a0, packed($t0)		# Print out the count for this character
	li		$v0, 1
	syscall

	li		$v0, 4					# Print a space
	la		$a0, SPACE
	syscall

	addi	$t0, $t0, 1
	b		finalLoop2

finalAfter2:
	li		$v0, 4					# Print out the length of the packed output
	la		$a0, PACKED_LEN
	syscall
	lw		$a0, packedLen
	li		$v0, 1
	syscall

	li		$v0, 10					# Terminate execution
	syscall

# DO NOT modify the following .data segment
# Your program should make use of the packed and packedLen labels to store the compressed data
.data
packedLen:		.word		0		# Length of packed data in bytes
packed:			.space		1024	# Enough memory for str to be of length 512 in the worst case

# Some string constants used by our code to print the final output
ORIG_TEXT:		.asciiz 	"Original text : "
ORIG_LEN:		.asciiz 	"\nOriginal len  : "
PACKED_PAIRS:	.asciiz 	"\nPacked pairs  : "
PACKED_LEN:		.asciiz 	"\nPacked len    : "
SPACE:			.asciiz 	" "

### START DATA ###
# This section will get replaced by the auto-grader.
# Do not place anything in this section required by your program.
# You can assume this section will always contain the label str.
# You can uncomment different lines to test your program.
# But you can (and should!) modify str to thoroughly test your program.
# We have provided 7 test strings with reference output on the assignment page.
.data
#str:	   		.asciiz		"AAAACCTGGGG"   									# test case 1
#str:	   		.asciiz		"AAABCDDDDDDEFGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG" 	# test case 2
#str:			.asciiz		"h" 												# test case 3
#str:			.asciiz		"ABCDEFGHIJKLMNOPQRSTUVWXYZ" 						# test case 4
#str:			.asciiz		"ABAABBAAACaA" 										# test case 5
str:			.asciiz		"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARGH!" # test case 6
#str:			.asciiz		"" 													# test case 7
### END DATA ###
