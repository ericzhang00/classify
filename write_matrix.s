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
    addi sp, sp, -44
    sw s0, 0(sp) #filename
    sw s1, 4(sp) #matr pointer
    sw s2, 8(sp)#rows
    sw s3, 12(sp)#columns   
    sw s4, 16(sp)#-1
    sw s5, 20(sp)# useless
    sw s6, 24(sp)# num elements or rows*cols
    sw s7, 28(sp)# file descriptor
    sw s8, 32(sp)# rows buffer
    sw s9, 36(sp)# cols buffer
    sw ra,  40(sp)

    #Putting Arguments in Saved Registers

    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0
    add s3, a3, x0

    #addi s4, x0, -1 #something holding -1
    addi s5, x0, 4 #something holding value 4
    mul s6, s2, s3 #total number of elements


    add a0, x0, x0  #setting a0=0
    add a1, s0, x0 #a1 -> string     
    addi a2, x0, 1 #a2 -> permission number
    jal fopen
    addi s4, x0, -1 
    beq a0, s4, eof_or_error  #error if open fails 
    add s7, x0, a0 #permission num
    #NO ERRORS TILL HERE

    #mallocing space for rows buffer
    addi a0, x0, 4 
    jal malloc
    add s8, x0, a0 #space fo s8
    sw s2, 0(s8)

    add a1, x0, s7
    add a2, s8, x0
    addi a3, x0, 1#a3 = 1
    addi a4, x0, 4
    jal fwrite
    bne a0, a3, eof_or_error

    #seems good so far

#mallocing space for columns buffer
    addi a0, x0, 4 
    jal malloc
    add s9, x0, a0 #space fo s9
    sw s3, 0(s9)

    add a1, x0, s7
    add a2, s9, x0
    addi a3, x0, 1#a3 = 1
    addi a4, x0, 4
    jal fwrite
    bne a0, a3, eof_or_error

#MATRIX WRITING
    add a1, s7, x0
    add a2, s1, x0
    add a3, s6, x0
    addi a4, x0, 4
    jal fwrite
    bne a0, a3, eof_or_error

#FILE CLOSING
    add a1, s7, x0
    jal fclose
    addi s4, x0, -1
    beq s4, a0, eof_or_error

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw ra,  40(sp)
    addi sp, sp, 44

    ret

eof_or_error:
    li a1 1
    jal exit2
