.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# a0 is the pointer to the start of m0
# a1 is the # of rows (height) of m0
# a2 is the # of columns (width) of m0
# a3 is the pointer to the start of m1
# a4 is the # of rows (height) of m1
# a5 is the # of columns (width) of m1
# a6 is the pointer to the the start of d
# Returns:
# None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions
    # Prologue
    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw ra, 24(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)
    #add s0, a0, x0 # address of pointer for m0
   # add s1, a1, x0 # height or number of rows of m0
    #add s2, a2, x0 # width or number of cols of m0 [STRIDE of v0]
    #add s3, a3, x0 # address of pointer for m1
    #add s4, a4, x0 # height or number of rows of m1 [STRIDE OF V2]
    #add s5, a5, x0 # width or number of cols of m2
    #add s6, a6, x0 #pointer to start of d
    add s0, x0, x0 #counter
    mul s1, a1, a5 #size of output array
    add s3, a1, x0 #numsrows of m1
    add s9, a2, x0
    add s4, a5, x0 #numcols of m2
    add s5, a3, x0 #second matrix's address
    #setting parameters
    add a0, a0, x0 #pointer to start of v0
    add a1, a3, x0# pointer to start of v1
    add a2, a4, x0 # length of vectors
    addi a3, x0, 1# stride of v0
    addi a4, s4, 0#stride of v1

outer_loop_start:
    beq s3, s0, outer_loop_end
    addi s0, s0, 1
    add s2, x0, x0 #innercounter
inner_loop_start:
    beq s2, s4, inner_loop_end
    addi s2, s2, 1
    add s6, x0, a0
    add s7, a6, x0
    add s8, a1, x0
    jal dot
    sw a0, 0(a6)
    add a1, s8, x0
    add a6, s7, x0
    add a0, x0, s6

    addi a6, a6, 4 #COULD BE COMPROMISED
    #addi s2, s2, 1
    addi a1, a1, 4 
    j inner_loop_start
inner_loop_end:
    
    addi a1, s5, 0
    addi s2, x0, 0
    addi t0, x0, 4
    mul t1, s9, t0 #possibly wrong
    add a0, a0, t1
    j outer_loop_start
outer_loop_end:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw ra, 24(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52
    ret

mismatched_dimensions:
    li a1 2
    jal exit2