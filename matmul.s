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
    bne a1, a5, mismatched_dimensions
    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw ra, 24(sp)
    add s0, a0, x0 # address of pointer for m0
    add s1, a1, x0 # height or number of rows of m0
    add s2, a2, x0 # width or number of cols of m0 [STRIDE of v0]
    add s3, a3, x0 # address of pointer for m1
    add s4, a4, x0 # height or number of rows of m1 [STRIDE OF V2]
    add s5, a5, x0 # width or number of cols of m2
    add s6, a6, x0 #pointer to start of d
    add t3, x0, x0 #counter
    mul t1, a1, a5 #size of output array
    add t5, x0, x0 #dots
    add t4, x0, x0 #innercounter

    add a0, s0, x0
    add a1, s3, x0
    mul a2, s4, s5
    addi a3, x0, 1
    addi a4, s4, 0

outer_loop_start:
    beq s1, t3, outer_loop_end
    addi t3, t3, 1 #outercounter 

inner_loop_start:
    beq t4, s5, inner_loop_end  
    addi s7, a0, 0 #temp for calling
    jal dot

    addi t5, a0, 0 
    sw t5, 0(s6)

    addi t2, a1, 0
    addi a1, t5, 0
    addi a0, x0, 1
    #ecall
    addi a1, x0, '\n'    # We want to print the newline character. Set a1 to '\n'.
    addi a0, x0, 11      # 11 is the code for printing a char. Set a0 to 11.
    #ecall

    addi a1, t2, 0
    add a0, s7, x0

    
    addi s6, s6, 4 #pushup pointer d by 4
    addi t4, t4, 1
    addi a1, a1, 4 #move up the second array first elem
    j inner_loop_start  
inner_loop_end:
    add a1, s3, x0 #reset first elem of second array
    add t4, x0, x0#reset counter
    addi t6, x0, 4
    mul s8, s1, t6 #pushup by whatever (fiist array) CONCERTNING
    add a0, a0, s8
    j outer_loop_start

#haha i mighta messed up
outer_loop_end:
    
    # Epilogue
    h:lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 28(sp)
    lw ra, 24(sp)
    lw s7, 32(sp)
    addi sp, sp, 36
    
    ret


mismatched_dimensions:
    li a1 2
    jal exit2