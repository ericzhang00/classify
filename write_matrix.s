.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)

    add s0, a0, x0 #set s0 to the first argument (the pointer to string representing the filename)
    add s1, a1, x0 #set s1 to the second argument(the pointer to the string representing the start of matrix)
    sw a2, 0(s2) # put a2 in memory in 0(s2) spot in memory (seems unnecessary)
    sw a3, 0(s3) # put a2 in memory in 0(s3) spot in memory(seems unnecessary)
    mul s4, a2, a3 #number of elements in matrix

    add a1, s0, x0 #a1 -> string     
    addi a2, x0, 1 #a2 -> permission number
    fopen
    addi t0, x0, -1 
    beq a0, t0, eof_or_error  #error if open fails 

    #seems good so far

    add a1, a0, x0 # a1 = unique integer tied ot file
    add a2, x0, s2# a2 = s2 -> s2 is a spot in a random memory spot (i only kinda get it)
    addi a3, x0, 1#a3 = 1
    addi a4, x0, 4
    fwrite
    bne a0, a3, eof_or_error

    add a2, x0, s3 #a2 = s3 which is a spot in memory
    addi a3, x0, 1 #a3 = 1 (write one element into the fwrite)
    addi a4, x0, 4 #a4 = 4
    fwrite
    bne a0, a3, eof_or_error

    add a2, x0, s1
    add a3, x0, s4
    addi a4, x0, 4
    fwrite
    bne a0, a3, eof_or_error

    fclose
    addi t1, x0, -1
    beq t1, a0, eof_or_error


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20

    ret

eof_or_error:
    li a1 1
    jal exit2
