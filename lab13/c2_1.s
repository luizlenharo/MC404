.data

.text
.globl swap_int
swap_int:
    addi sp, sp, -8
    lw t0, 0(a0)   
    sw t0, 4(sp)
    lw t0, 0(a1)   
    sw t0, 0(sp)

    lw t1, 0(sp)
    sw t1, 0(a0)
    lw t1, 4(sp)
    sw t1, 0(a1)

    li a0, 0
    addi sp, sp, 8
    ret

.globl swap_short
swap_short:
    addi sp, sp, -8
    lh t0, 0(a0)   
    sw t0, 4(sp)
    lh t0, 0(a1)   
    sw t0, 0(sp)

    lw t1, 0(sp)
    sh t1, 0(a0)
    lw t1, 4(sp)
    sh t1, 0(a1)

    li a0, 0
    addi sp, sp, 8
    ret

.globl swap_char
swap_char:
    addi sp, sp, -8
    lb t0, 0(a0)   
    sw t0, 4(sp)
    lb t0, 0(a1)   
    sw t0, 0(sp)

    lw t1, 0(sp)
    sb t1, 0(a0)
    lw t1, 4(sp)
    sb t1, 0(a1)

    li a0, 0
    addi sp, sp, 8
    ret