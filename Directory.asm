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
	
####### Print "Searching for: keyword" ########
	la		$a0, src4
	li		$v0, 4
	syscall
	la		$a0, keyword
	li		$v0, 4
	syscall
	la		$a0, newLine
	li		$v0, 4
	syscall
###############################################
#       Loop through each node and compare    #
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
#      empIndex -> $t0
###############################################
	li		$t5, 65		# A
	li		$t6, 90		# Z
	la		$t0, first	# Grab the first person
	li		$t4, 0 		# Keyword Index Count
loop:
	beq		$t0, -1, exit # End of list? Cool
	lw		$t1, 4($t0) # EmpID
	lb		$t2, 8($t0) # Age
	la		$t3, 9($t0) # Name
	move	$t9, $t0
loopM:
	lb		$t7, 0($t3) # Get current empName index char
	lb		$t8, keyword($t4) # Grab keyword index char
	beqz	$t8, print	# If end of keyword, we have a match! Print that baby
	beqz	$t7, skipPrint # If end of empName, move to next node
##### Force lowercase both empName and keyword #
	blt		$t7, $t5, isLower 
	bgt		$t7, $t6, isLower
	addi	$t7, $t7, 32
isLower:
	blt		$t8, $t5, isLowKey 
	bgt		$t8, $t6, isLowKey
	addi	$t8, $t8, 32
isLowKey:
####### Compare chars, if a match, i++ ########
	addi	$t3, $t3, 1 # Always increment empName
	bne		$t7, $t8, reset
	addi	$t4, $t4, 1 # keyword match count ++
	b		loopM
reset:
	li		$t4, 0
	b 		loopM
####### Refresh empName, print empData ########
print:
	li		$t4, 0		# Reset keyword index = 0
	la		$t3, 9($t0)	# Grab Name [2 words + 1 byte = 9]
	# Print Name
	move	$a0, $t3
	li		$v0, 4
	syscall
	
	# Be Blessed
	la		$a0, blessed
	li		$v0, 4
	syscall
	
	# Print EmpID
	move	$a0, $t1
	li		$v0, 1
	syscall
	
	# Print Age
	la		$a0, age
	li		$v0, 4
	syscall
	
	# Print Age?
	move	$a0, $t2
	li		$v0, 1
	syscall
	
	# New Line
	la		$a0, newLine
	li		$v0, 4
	syscall
	
	lw		$t0, 0($t0) # Pointer set to next node
	b 		loop
	
skipPrint:
	move 	$t0, $t9
	lw		$t0, 0($t0) # Move to next node address
	li		$t4, 0		# Reset keyword index = 0	
	b 		loop
exit:

###############################################
#       Saved strings, other utils            #
###############################################
.data
src4:		.asciiz		"Searching for: "
age:		.asciiz		", age "
newLine:	.asciiz		"\n"
blessed:	.asciiz		", #"

###############################################

### START DATA ###
# You can (and should!) modify the linked list in order to test your program, but:
#  1) the keyword to search for should retain the label keyword
#  2) the first node should retain the label first
# You can (and should!) have a separate .data section containing other variables (e.g. string constants).
# NOTE: we will replace everything between the START DATA and END DATA tags during testing!
.data
keyword:    .asciiz     "a"                    # String to search for, NOTE: this may be empty (matches everyone)


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
