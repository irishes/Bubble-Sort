# Bubblesort
# Brandon Kindrick 2016
# Made in Mars

.data
    howManyNumbersPrompt:     .asciiz "How many numbers are you inputting? \n"
    howManyNumbersError:      .asciiz "Your input was less than 1 or greater than 10 \n"
    enterANumberPrompt:       .asciiz "Enter a number: \n"
    endMessage:               .asciiz "Sorted array: \n"
    space:                    .asciiz " "
     
                              .align 4
    sortArray:                .space 40
    sortedArray:              .space 40

.text
    # Main Method
    main:
        jal readNums                      # First jumps to readNums
        li $t2, 0                         # Sets $t2 to 0
        jal bSort                         # Jumps to bSort
        la $a0, endMessage                # Loads the message
        li $v0, 4                         # Prints the message
        syscall
        li $t1, 0                         # Loads 0 into $t1
        li $t2, 0                         # Loads 0 into $t2
        jal printNums                     # Jumps to printNums
        jal exit                          # Jumps to exit
        syscall     

    # Prompts the user to input the amount of number they want
    readNums: 
    	la $s0, sortArray                 # Load the sortArray
        la $a0, howManyNumbersPrompt      # Point to prompt   
        li $v0 , 4                        # Print prompt
        syscall
        li $v0, 5                         # Read the user's input
        syscall
        move $s1, $v0                     # Save the user's input to $s1
        blt $s1, 1, readNumsError         # Branch if the input is less than 1
        bgt $s1, 10, readNumsError        # Branch if the input is greater than 10
        li $t4, 4                         # Loads 4 into $t4
        mult $s1, $t4                     # Multiplys 4 and $s1
        mflo $t0                          # Moves the result into $t0
        move $s3, $t0                     # Saves the result into #s3
        li $t2, 0                         # Resets to 0
        b readNumsLoop                    # Branches to readNumsLoop
    
    # Prompts the user for (count) numbers and adds them to the array     
    readNumsLoop:
        beq $s3, $t2, end                 # Branches if $s3 is equal to $t2
        addi $t2, $t2, 4                  # Adds for to the index every iteration
        la $a0, enterANumberPrompt        # Loads the prompt
        li $v0, 4                         # Prints the prompt
        syscall
        li $v0, 5                         # Gets the user's input
        syscall
        move $t1, $v0                     # Moves the result to $t1
        sw $t1, sortArray($t2)            # Stores the number in the current index of sortArray
       	b readNumsLoop                    # Loops back to readNumsLoop
        
    # Prompts the user with an error, if an incorrect number is inputted
    readNumsError:
        la $a0, howManyNumbersError       # Loads the prompt
        li $v0, 4                         # Prints the prompt
        syscall
        b readNums                        # Branches to readNums
        
    # Jumps     
    end:
        jr $ra
        
    # Bubble Sort     
    bSort:
        beq $s3, $t2, outLoop             # Branches to outLoop if the count = $s3
        addi $t5, $t2, 4                  # Adds 4 to the index and saves to $t5
        lw $t6, sortArray($t2)            # Loads the first index to $t6
        lw $t7, sortArray($t5)            # Loads the next index to  $t7
        bge $t7, $t6, skipTheSwap         # Branches to skipTheSwap if they are in the correct order
        sw $t6, sortArray($t5)            # Swaps the two indexes 
        sw $t7, sortArray($t2)            # ^
        addi $t2, $t2, 4                  # Adds 4 to get the next index
        j bSort                           # Loops back to bSort
    
    # Skips the swap      
    skipTheSwap:
        addi $t2, $t2, 4                  # Does not swap and moves to the next index
        j bSort                           # Jumps back to bSort
    
    # Outer loop
    outLoop:
        li $t2, 0                         # Resets $t2 to 0
        addi $t1, $t1, 1                  # Adds 1 to $t1
        beq $t1, $s3, end                 # Branches to the end of readNums  
        j bSort                           # Jumps back to bSort
    
    # Prints each element of the inputted array    
    printNums:
        beq $s3, $t2, exit                # Branches if the index is greater than or equal to count
	addi $t2, $t2, 4                  # Adds 4 to the current index
	lw $t4, sortArray($t2)            # Loads sortArray($t0) to $t2
	move $a0, $t4                     # Moves the current index to the argument
	li $v0, 1                         # Prints current index
	syscall
	la $a0, space                     # Prints the space
        li $v0, 4                         # Loads the space
        syscall
	b printNums                       # Jumps back to the loop
        
    # Exits the program
    exit:
        li $v0, 10
        syscall
