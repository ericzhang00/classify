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

    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    add s0, x0, a0 #address of pointer v0
    add s1, x0, a1 #address of pointer v1
    lw s2, 0(a2) #size of pointer
    add s3, x0, x0 #counter of pointer

    add t0, x0, x0 #dot product

loop_start:


  bge s3, s2, loop_end
  lw t1, 0(s0) #element of v0
  lw t2, 0(s1) #element of v1
  mul t3, t1, t2 #product of elements
  add t0, t0, t3 #incrementing dot product
  add t4, a3, a3
  add t4, t4, t4 #stride v0
  mul t5, a4, a4
  add t5, t5, t5 #stride v1
  add s0, s0, t4
  add s1, s1, t5
  addi s3, s3, 1

  j loop_start

loop_end:


    # Epilogue

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    addi sp, sp, 16
    add a0, t0, x0
    ret
