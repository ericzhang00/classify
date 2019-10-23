.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:

    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)

    # Read matrix into memory
    #Fairly Confident it works
    #row memory
    addi a0, x0, 4
    jal malloc
    add s3, a0, x0

    #col memory
    addi a0, x0, 4
    jal malloc
    add s4, a1, x0

    la a0, file_path
    add a1, s3, x0
    add a2, s4, x0

    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0

    # Print out elements of matrix
    jal read_matrix #gets matrix values and a0 pointer is set to that

    add a0, s0, x0
    add a1, s1, x0
    add a2, s2, x0

    jal print_int_array#prints individual integer valuez

    # Terminate the program
    addi a0, x0, 10
    ecall

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20

    jal exit
