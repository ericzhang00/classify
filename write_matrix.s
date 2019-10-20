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
    sw s1, 0(sp)
    sw s2, 0(sp)
    sw s3, 0(sp)
    sw s4, 0(sp)
    add s0, a0, x0
    add s1, a1, x0
    sw a2, 0(s2)
    sw a3, 0(s3)
    mul s4, a2, a3 #number of elements in matrix

    add a1, s0, x0
    addi a2, x0, 1
    fopen
    addi t0, x0, -1
    beq a0, t0, eof_or_error  #error if open fails

    add a1, a0, x0
    add a2, x0, s2
    addi a3, x0, 1
    addi a4, x0, 4
    fwrite
    bne a0, a3, eof_or_error
    add a2, x0, s3
    addi a3, x0, 1
    addi a4, x0, 4
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
    lw s1, 0(sp)
    lw s2, 0(sp)
    lw s3, 0(sp)
    lw s4, 0(sp)
    addi sp, sp, 20

    ret

eof_or_error:
    li a1 1
    jal exit2
