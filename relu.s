.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 is the pointer to the array
#   a1 is the # of elements in the array
# Returns:
#   None
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    add s0, x0, a0 #address of pointer
    add s1, x0, a1 #size of pointer
    add s2, x0, x0 #counter of pointer
    #add a1, s1, x0      # Set a1 to the value returned by the factorial.
      # 1 is the code for printing an integer. Set a0 to 1.
    #ecall
loop_start:
    addi s2, s2, 1
    bgt s2, s1, loop_end
    j loop_continue

loop_continue:
    lw t0, 0(s0)
    slt t0, x0, t0
    beq t0, x0, smaller
  h:addi s0, s0, 4
    j loop_start
smaller:
    sw x0, 0(s0)
    j h
loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    ret
