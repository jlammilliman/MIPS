#    File :	 Directory.asm
# @author :  Justin Milliman - jlmillim
#   Email :	 jlmillim@mtu.edu
#    Date :	 2/6/2021
# CS 1142 :  Programming at the Hardware Software Interface - R01
###############################################
# This program searches a linked-list of nodes for employeee data
# based on a keyword. The keyword is not case-sensitive, and is 
# not limited to just characters [A-z].
#
#  Example Input :	"im "
# Example Output :	Jim D. Halpert, #20030422, age 27
#
###############################################


####### Read and print the keyword ############
	la		$a0, kyw
	li		$v0, 4
	syscall
	la		$a0, keyword
	syscall
	la		$a0, kyw2
	syscall
	
	la		$a0, newLine
	syscall
	
####### Convert keyword [A-Z] -> [a-z] #########
	li		$t0, 0
	li		$t1, 65 # A
	li		$t2, 90 # Z
loop1:
	lbu		$t3, keyword($t0)
	beqz	$t3, done1
	blt		$t3, $t1, next1
	bgt		$t3, $t2, next1
	addi	$t3, $t3, 32
	sb		$t3, keyword($t0)
next1:
	add		$t0, $t0, 1
	b  		loop1
	
done1:
####### Print "Searching for: keyword" ########
	la		$a0, src4
	syscall
	la		$a0, keyword
	syscall
	la		$a0, newLine
	syscall

###############################################
#       Iterate through nodes                 #
###############################################
	la		$t0, first			# Grab the first person
	
loopNodes:	
	lw		$t1, 4($t0)		# Grab EmpID
	lb		$t2, 8($t0)		# Grab Age
	la		$t3, 9($t0)		# Grab Name [2 words + 1 byte = 9]
	
	b 	matchMaker # Go to the matching algorithm now that we have things to play with
	returnMatch:

	# Print Name
	move	$a0, $t3
	li		$v0, 4
	syscall
	
	# Print a ", "
	la		$a0, cmmSpc
	li		$v0, 4
	syscall
	
	# Print EmpID
	move	$a0, $t1
	li		$v0, 1
	syscall

	# Print a ", "
	la		$a0, cmmSpc
	li		$v0, 4
	syscall
	
	# Print Age
	move	$a0, $t2
	li		$v0, 1
	syscall
	
	la		$a0, newLine
	li		$v0, 4
	syscall
	
skipPrint:
	lw		$t0, 0($t0)		# Pointer set to next node
	bne		$t0, -1, loopNodes


	b 		voidMe # If you get here naturally, skip
###############################################
#       Time to find some long lost love      #
###############################################
# The general process here:
# 	[1] Take the first letter of empName and convert to lowercase
# 	[2] Compare that letter to the first letter of keyword[lowercased]
#	[3] If the letter matches, move to the next letter in empName
#		- [4] For each letter in keyword, compare to adjusted index in empName
#		- [5] If we reach the end of keyword, and found consecutive character match in empName, return and print name
#		- [6] If we did not find a match, repeat loop
#	[7] If the first letter of keyword[lowercase] does not match adjusted index of empName, move to next index in empName
#	[8] Keep looking for a match to keyword[lowercase] until no more characters exist in empName
#
####### For my Small Brain ####################
#	empName -> $t3
#	 empAge -> $t2
#	  empID -> $t1
#  empIndex -> $t0
###############################################
matchMaker:
	move	$t4, $t0
	
	move	$a0, $t4
	li		$v0, 4
	syscall
	
	li		$t8, 0 	# keyword[lowercase] index
	li		$t5, 65 # A
	li		$t6, 90 # Z
loopMatch:
	lbu		$t9, keyword($t8)
	beqz	$t9, returnMatch	# If we reach the length of keyword, we found a match
	beqz	$t4, skipPrint		# If we have reached the end of empName, and not exited with a match, do not print this employee
	blt		$t4, $t5, nextMatch
	bgt		$t4, $t6, nextMatch
	addi	$t4, $t4, 32
nextMatch:
	beq		$t7, $t9, charMatchFound
	li		$t8, 0	# If its not a matched char, reset matched keyword[lowercase] chars to 0
	b 		skipMe3	# Do not run this if we get here naturally
charMatchFound:
	addi	$t8, $t8, 1	# One more matched char for keyword[lowercase]
skipMe3:
	add		$t4, $t4, 1
	b  		loopMatch	
	
	
	
voidMe:
###############################################
#       Saved strings, other utils            #
###############################################
.data
src4:		.asciiz		"Searching for: "
kyw:		.asciiz		"*** Keyword: \""
kyw2:		.asciiz		"\" ***"
age:		.asciiz		"age "
newLine:	.asciiz		"\n"
cmmSpc:		.asciiz		", "

# Hold onto useful employees
empName:	.space	 	40

###############################################

### START DATA ###
# You can (and should!) modify the linked list in order to test your program, but:
#  1) the keyword to search for should retain the label keyword
#  2) the first node should retain the label first
# You can (and should!) have a separate .data section containing other variables (e.g. string constants).
# NOTE: we will replace everything between the START DATA and END DATA tags during testing!
.data
keyword:    .asciiz     "m"                    # String to search for, NOTE: this may be empty (matches everyone)


first:      .word       node2                   # Next pointer
            .word       20030422                # Employee ID
            .byte       27                      # Age
            .asciiz     "Jim D. Halpert"        # Name, NOTE: you can assume this will NOT be empty
node2:      .word       node3
            .word       20030435
            .byte       26
            .asciiz     "Pam M. Beesly"
node3:      .word       node4
            .word       20010984
            .byte       41
            .asciiz     "Michael G. Scott"
node4:      .word       node5
            .word       20030580
            .byte       31
            .asciiz     "Dwight K. Schrute III"
node5:      .word       node6
            .word       20010321
            .byte       24
            .asciiz     "Ryan B. Howard"
node6:      .word       node7
            .word       20051229
            .byte       32
            .asciiz     "Andy B. Bernard Jr."
node7:      .word       -1
            .word       20084724
            .byte       45
            .asciiz     "Robert California"
### END DATA ###

