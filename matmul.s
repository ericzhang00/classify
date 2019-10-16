.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions
    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    add s0, a0, x0 # address
    add s1, a1, x0 # height or number of rows of m0
    add s2, a2, x0 # width or number of cols of m0 [STRIDE of v0]
    add s3, a3, x0 # address of pointer
    add s4, a4, x0 # height or number of rows of m1 [STRIDE OF V2]
    add s5, a5, x0 # width or number of cols of m2
    add s6, a6, x0 #pointer to start of d
    add t3, x0, x0 #counter
   	mul t1, a1, a5 #size of output array
outer_loop_start:
	bgt t1, t3, inner_loop_start
	beq t1, t3, outer_loop_end
inner_loop_start:
	addi t3, t3, 1
	add a0, s0, x0
	add a1, s3, x0
	mul a2, s1, s2
	add a3, s2, x0
	add a4, s4, x0
	jal dot
	sw s6, 0(a0)
	addi s6, s6, 4
	addi s0, s0, 4
	addi s3, s3, 4
	j outer_loop_start
inner_loop_end:
	#haha i mighta messed up
outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    addi sp, sp, 24

    ret


mismatched_dimensions:
    li a1 2
    jal exit2
