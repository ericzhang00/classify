.import ../write_matrix.s
.import ../utils.s

.data
m0: .word 1, 2, 3, 4, 5, 6, 7, 8, 9 # MAKE CHANGES HERE
file_path: .asciiz "test_output.bin"

.text
main:
    # row memory
    addi a0, x0, 4
    jal malloc
    add t0, a0, x0

    #col memory
    addi a0, x0, 4
    jal malloc
    add t1, a1, x0

    la a0 file_path
    la a1 m0
    add a2, x0, t0
    add a3, x0. t1

    jal write_matrix #gets matrix values and a0 pointer is set to that
    # Exit the program
    addi a0 x0 10
    ecall