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
    add s1, x0, a1 #size of pointer
    add s2, x0, x0 #counter of pointer
    #addi a0, x0, 1
         # Set a1 to the value returned by the factorial.
      # 1 is the code for printing an integer. Set a0 to 1.
    #ecall
    
loop_start:
    lw t0, 0(s0) #biggestVal
    add t1, s2, x0 #biggestIndex 
loop_continue:
    addi s2, s2, 1
    bge s2, s1, loop_end
    addi s0, s0, 4
    lw t2, 0(s0) # curr
    #addi a1, t2, 0
    #ecall
    bgt t2, t0, bigger
    h: j loop_continue
bigger:
    lw t0, 0(s0)
    add t1, s2, x0
    j h
loop_end:
    # Epilogue
    add a0, t1, x0
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    ret
