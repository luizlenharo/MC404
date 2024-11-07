.data

.text
.globl my_function

my_function:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw a2, 0(sp)

    lw t0, 8(sp)
    lw t1, 4(sp)
    add t4, t0, t1   #sum 1
    mv a0, t4
    lw a1, 8(sp)
    jal ra, mystery_function

    lw t0, 4(sp)
    sub t0, t0, a0  #dif 1
    lw t1, 0(sp)                
    add t5, t0, t1  #sum 2
    mv a0, t5
    lw a1, 4(sp)
    jal ra, mystery_function

    lw t0, 0(sp)
    sub t6, t0, a0  #dif 2
    add a0, t6, t5  #sum 3

    lw ra, 12(sp)
    addi sp, sp, 16
    ret