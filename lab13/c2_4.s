.data

.text
.globl node_op
node_op:
    lw t0, 0(a0)       #a
    addi a0, a0, 4
    lb t1, 0(a0)       #b
    addi a0, a0, 1
    lb t2, 0(a0)       #c
    addi a0, a0, 1
    lh t3, 0(a0)       #d

    add a0, t0, t1
    sub a0, a0, t2
    add a0, a0, t3
    ret
