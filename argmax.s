.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    add s0, x0, a0 #address of pointer
    lw s1, 0(a1) #size of pointer
    add s2, x0, x0 #counter of pointer

    addi t0, x0, x0 #biggest
    addi t1, x0, x0 #smallest
    addi t2, x0, x0

loop_start:
    addi s2, s2, 1
    bge s2, s1, loop_end
    j loop_continue

loop_continue:
    lw t0, 0(s0)
    bgt 0(s0), t0, bigger
    blt 0(s0), t0, smaller
    
bigger:
lw t0, 0(s0)
    addi s0, s0, 4
    j loop_start
smaller:
    lw s0, 0(x0)
    addi s0, s0, 4
    j loop_start

loop_end:

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    ret
