.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:
    # Read matrix into memory
    #Fairly Confident it works
    #row memory
    addi a0, x0, 4
    jal malloc
    add t0, a0, x0

    #col memory
    addi a0, x0, 4
    jal malloc
    add t1, a1, x0

    la a0, file_path
    add a1, t0, x0
    add a2, t1, x0

    # Print out elements of matrix
    jal read_matrix #gets matrix values and a0 pointer is set to that
    jal print_int_array#prints individual integer valuez

    # Terminate the program
    addi a0, x0, 10
    ecall

    jal exit