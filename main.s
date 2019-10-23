.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args
    bne a0, 5, error





	# =====================================
    # LOAD MATRICES
    # =====================================
    add s0, a1, x0 #set s0 = a1 or char array of command line arguments

    # Load pretrained m0
    addi a0, x0, 4
    jal malloc
    add s1, a0, x0 #t0 = a0

    addi a0, x0, 4
    jal malloc
    add s2, a0, x0

    lw a0, 4(s0) #MO_Path
    add a1, x0, s1
    add a2, x0, s2
    jal read_matrix
    add s3, x0, a0

    # Load pretrained m1
    addi a0, x0, 4
    jal malloc
    add s4, a0, x0 #malloced space

    addi a0, x0, 4
    jal malloc
    add s5, a0, x0

    lw a0, 8(s0) #M1_Path
    add a1, x0, s4
    add a2, x0, s5
    jal read_matrix
    add s6, x0, a0
    # Load input matrix

    addi a0, x0, 4
    jal malloc
    add s7, a0, x0 #malloced space

    addi a0, x0, 4
    jal malloc
    add s8, a0, x0

    lw a0, 12(s0) #M1_Path
    add a1, x0, s7
    add a2, x0, s8
    jal read_matrix
    add s9, a0, x0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    addi a0, x0, 4
    jal malloc
    add s10, a0, x0 #ALLOCATING SPACE FOR POINTER, how much space is necessary 4 or 4*rows*cols??

    add a0, s3, x0
    add a1, s1, x0
    add a2, s2, x0
    add a3, s9, x0
    add a4, s7, x0
    add a5, s8, x0
    add a6, s10, x0


    jal matmul

    #NONLINEAR LAYER
    mul t3, s1, s5 #size of array
    add a0, a6, x0 #setting inputs for relu funciton
    add a1, t3, x0 #size of output array
    jal relu

    #LAST LINEAR LAYER
    addi a0, x0, 4
    jal malloc
    add s11, a0, x0 #ALLOCATING SPACE FOR POINTER, how much space is necessary 4 or 4*rows*cols??

    add a0, s6, x0
    add a1, s8, x0
    add a2, s7, x0
    add a3, s10, x0
    add a4, s1, x0
    add a5, s5, x0
    add a6, s11, x0
    jal matmul
    #final is in s11

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s0) # Load pointer to output filename
    add a1, s6, x0
    add a2, s8, x0
    add a3, s5, x0
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mul t4, s8, s5
    add a1, x0, t4 #number of elements
    add a0, x0, s6#pointer to array
    jal argmax

    # Print classification
    add a1, a0. x0
    jal print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit

    error:
      li a1 3
      jal exit2
