.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -16
    sw s0, 0(sp)
	  sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)

    add s0, x0, a0
    add s1, x0, a1
    add s2, x0, a2

    addi a0, x0, 4
    malloc #a0 now points to 4 bytes
    add s1, x0, a0

    addi a0, x0, 4
    malloc #a0 now points to 4 bytes
    add s2, x0, a0

    add a1, x0, s0  #a1 is pointer to string with filename
    add a2, x0, x0  #a2 is integer denoting read only

    fopen
    addi t0, x0, -1
    beq a0, t0, eof_or_error  #error if open fails

    #a0 now file descriptor

    add a1, a0, x0

    add a2, s1, x0
    addi a3, x0, 4
    fread

    add a2, s2, x0
    addi a3, x0, 4
    fread

    lw t1, 0(s1)
    lw t2, 0(s2)
    mul t3, t1, t2
    slli t3, t3, 2
    add a0, t3, x0
    malloc  #allocates rows x columns x 4 bytes for matrix
    #a0 now pointer to allocated bytes
    add s3, x0, a0

    add a2, s3, x0
    add a3, t3, x0
    fread
    bne a0, a3, eof_or_error

    fclose
    addi t4, x0, -1
    beq t4, a0, eof_or_error

    add a0, s3, x0
    add a1, s1, x0
    add a2, s2, x0


    # Epilogue
    lw s0, 0(sp)
	  lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    addi sp, sp, 16

    ret

eof_or_error:
    li a1 1
    jal exit2
