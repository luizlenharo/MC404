.data

.text
.globl fill_array_int
fill_array_int:
    addi sp, sp, -4
    sw ra, 0(sp)
    li t0, 0
    li t1, 100
    addi sp, sp, -400
    mv t2, sp
    j loop_1
    loop_1:
        beq t0, t1, end_1
        sw t0, 0(t2)
        addi t0, t0, 1
        addi t2, t2, 4
        j loop_1

    end_1:
        mv a0, sp
        jal ra, mystery_function_int
        addi sp, sp, 400
        lw ra, 0(sp)
        addi sp, sp, 4
        ret

.globl fill_array_short
fill_array_short:
    addi sp, sp, -4
    sw ra, 0(sp)
    li t0, 0
    li t1, 100
    addi sp, sp, -200
    mv t2, sp
    j loop_2
    loop_2:
        beq t0, t1, end_2
        sh t0, 0(t2)
        addi t0, t0, 1
        addi t2, t2, 2
        j loop_2

    end_2:
        mv a0, sp
        jal ra, mystery_function_short
        addi sp, sp, 200
        lw ra, 0(sp)
        addi sp, sp, 4
        ret

.globl fill_array_char
fill_array_char:
    addi sp, sp, -4
    sw ra, 0(sp)
    li t0, 0
    li t1, 100
    addi sp, sp, -100
    mv t2, sp
    j loop_3
    loop_3:
        beq t0, t1, end_3
        sb t0, 0(t2)
        addi t0, t0, 1
        addi t2, t2, 1
        j loop_3

    end_3:
        mv a0, sp
        jal ra, mystery_function_char
        addi sp, sp, 100
        lw ra, 0(sp)
        addi sp, sp, 4
        ret