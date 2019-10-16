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
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    add s0, x0, a0 #address of pointer m0
    add s1, x0, a3 #address of pointer m1
    add s2, x0, a1 #size of outer pointer m0
    add s3, x0, a5 #size of inner pointer m1
    add s4, x0, x0 #outer counter m0
    add s5, x0, x0 #inner counter m1
    add s6, x0, a2 #iterate along m0
    add s7, x0, a6 #pointer to start of d

outer_loop_start:
	bge s4, s2, outer_loop_end
  j inner_loop_start

inner_loop_start:
  bge s5, s3, inner_loop_end
  add a0, s0, x0
  add a1, s1, x0
  add a2, s6, x0
  addi a3, x0, 1
  add a4, s3, x0
  jal dot
  sw a0, 0(s7)

  addi s7, s7, 4
  addi s1, s1, 4
  addi s5, s5, 1
  j inner_loop_start

inner_loop_end:
	add s5, x0, x0 #reset inner loop counter
  add t2, s6, s6
  add t2, t2, t2
  add s0, s0, t2 #move to next row of m0
  addi s4, s4, 1
  j outer_loop_start

outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    addi sp, sp, 32

    ret


mismatched_dimensions:
    li a1 2
    jal exit2
