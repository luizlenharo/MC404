.data

.text
.globl node_creation
node_creation:
    addi sp, sp, -4
    sw ra, 0(sp)
    addi sp, sp, -8
    mv t2, sp
    li t0, 30
    sw t0, 0(t2)
    addi t2, t2, 4
    li t0, 25
    sb t0, 0(t2)
    addi t2, t2, 1
    li t0, 64
    sb t0, 0(t2)
    addi t2, t2, 1
    li t0, -12
    sh t0, 0(t2)
    mv a0, sp
    jal ra, mystery_function
    addi sp, sp, 8
    lw ra, 0(sp)
    addi sp, sp, 4
    ret