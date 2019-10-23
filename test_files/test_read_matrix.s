.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:

    addi sp, sp, -28
    sw s0, 8(sp)
    sw s1, 12(sp)
    sw s2, 16(sp)
    sw s3, 20(sp)
    sw s4, 24(sp)

    # Read matrix into memory
    #Fairly Confident it works
    #row memory
    #addi a0, x0, 4
    #jal malloc
    #add s3, a0, x0

    #col memory
    #addi a0, x0, 4
    #jal malloc
    #add s4, a1, x0

    la a0, file_path
    add a1, sp, x0
    addi a2, sp, 4

    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0

    # Print out elements of matrix
    jal read_matrix #gets matrix values and a0 pointer is set to that

    lw t0, 0(s1)
    add a1, t0, x0
    lw t1, 0(s2)
    add a2, t1, x0

    jal print_int_array#prints individual integer valuez

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20

    # Terminate the program
    addi a0, x0, 10
    ecall
