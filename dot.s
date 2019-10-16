.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:

    # Prologue

    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    add s0, x0, a0 #address of pointer v0
    add s1, x0, a1 #address of pointer v1
    add s2, a2, x0 #size of pointer
    add s3, x0, x0 #counter of pointer v0
    add s4, x0, x0 #counter of pointer v1
    add s5, x0, x0 #numcounter
    add t0, x0, x0 #dot product
    addi t4, x0, 4
    mul t5, a3, t4 #strideadd v0
    mul t6, a4, t4#strideadd v1
loop_start:


  bge s3, s2, loop_end
  lw t1, 0(s0) #element of v0
  lw t2, 0(s1) #element of v1
  mul t3, t1, t2 #product of elements
  add t0, t0, t3 #incrementing dot product
  add s3, s3, a3#stride v0
  add s4, s4, a4 #stride v1
  add s0, s0, t5
  add s1, s1, t6
  addi s5, s5, 1

  j loop_start

loop_end:
    # Epilogue

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    addi sp, sp, 24
    add a0, t0, x0
    ret
