.data

.text
.globl operation
operation:
    lw t0, 0(sp)    #i
    lw t1, 4(sp)    #j
    lw t2, 8(sp)    #k
    lw t3, 12(sp)   #l
    lw t4, 16(sp)   #m
    lw t5, 20(sp)   #n
    addi sp, sp, -28
    sw ra, 24(sp)
    sw a0, 20(sp)
    sw a1, 16(sp)
    sw a2, 12(sp)
    sw a3, 8(sp)
    sw a4, 4(sp)
    sw a5, 0(sp)
    addi sp, sp, -8
    sw a6, 4(sp)
    sw a7, 0(sp)
    mv a0, t5
    mv a1, t4
    mv a2, t3
    mv a3, t2
    mv a4, t1
    mv a5, t0
    lw t0, 0(sp)
    mv a6, t0
    lw t0, 4(sp)
    mv a7, t0
    addi sp, sp, 8
    jal ra, mystery_function

    lw ra, 24(sp)
    addi sp, sp, 28
    ret
