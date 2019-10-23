.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:
    # Read matrix into memory
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
    jal read_matrix
    jal print_int_array

    # Terminate the program
    addi a0, x0, 10
    ecall

    jal exit