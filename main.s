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
    addi t0, x0, 5
    bne a0, t0, error

    add t1, x0, a1
    add a1, x0, a0
    #jal print_int
    add a1, t1, x0

	# =====================================
    # LOAD MATRICES
    # =====================================

    #s0 refers to command line args
    #s1 is malloced space for rows of m0
    #s2 is malloced space for cols of m0
    #s3 is malloced space for red matrix of m0
    #s4 is malloced space for rows of m1
    #s5 is malloced space for cols of m1
    #s6 is malloced space for red matrix of m1
    #s7
    #s8
    #s9
    #s10
    #s11

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

    add t1, x0, a1
    addi a1, x0, 2
    #jal print_int
    add a1, t1, x0

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

    add t1, x0, a1
    addi a1, x0, 3
    #jal print_int
    add a1, t1, x0
    # Load input matrix

    addi a0, x0, 4
    jal malloc
    add s7, a0, x0 #malloced space

    addi a0, x0, 4
    jal malloc
    add s8, a0, x0

    lw a0, 12(s0) #INPUT
    add a1, x0, s7
    add a2, x0, s8
    jal read_matrix
    add s9, a0, x0

    add t1, x0, a1
    addi a1, x0, 4
    #jal print_int
    add a1, t1, x0
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    #FIRST LINEAR LAYER
    lw t0, 0(s1)
    lw t1, 0(s8)
    mul t1, t1, t0
    addi t0, x0, 4
    mul a0, t1, t0

    jal malloc
    add s10, a0, x0 

    add a0, s3, x0
    lw a1, 0(s1)
    lw a2, 0(s2)
    add a3, s9, x0
    lw a4, 0(s7)
    lw a5, 0(s8)
    add a6, s10, x0

    jal matmul

    add t1, x0, a1
    addi a1, x0, 100
    #jal print_int
    add a1, t1, x0

    #NONLINEAR LAYER
    

    lw t0, 0(s1)
    lw t1, 0(s8)
    mul t3, t0, t1 #size of array
    add a0, s10, x0 #setting inputs for relu funciton
    add a1, t3, x0 #size of output array

    jal relu

    add t1, x0, a1
    add t2, x0, a2
    add t3, x0, a3
    add a0, s10, x0
    lw a1, 0(s1)
    lw a1, 0(s8)
    #jal print_int_array
    add a1, t1, x0
    add a2, t2,  x0
    add a3, t3, x0


    #LAST LINEAR LAYER
    

    lw t0, 0(s4)
    lw t1, 0(s8)
    mul t1, t1, t0
    addi t0, x0, 4
    mul a0, t1, t0

    jal malloc
    add s11, a0, x0 

    add a0, s6, x0
    lw a1, 0(s4)
    lw a2, 0(s5)
    add a3, s10, x0
    lw a4, 0(s1)
    lw a5, 0(s8)
    add a6, s11, x0

    add t1, x0, a1
    add a1, x0, a6 
    #jal print_int
    add a1, t1, x0

    jal matmul
    #final is in s11

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s0) # Load pointer to output filename
    add a1, s11, x0 #Pointer in memory
    lw a2, 0(s4)
    lw a3, 0(s8)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw t0, 0(s4)
    lw t1, 0(s8)
    mul t0, t0, t1

    add a1, x0, t0 #number of elements
    add a0, x0, s11#pointer to array
    jal argmax
    # Print classification
    add a1, a0, x0
    jal print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit

    error:
      li a1 3
      jal exit2
