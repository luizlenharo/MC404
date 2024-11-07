.data

.text
.globl middle_value_int
middle_value_int:
    li t1, 2
    div t0, a1, t1
    li t1, 4
    mul t0, t0, t1
    add a0, t0, a0
    lw a0, 0(a0)
    ret

.globl middle_value_short
middle_value_short: 
    li t1, 2
    div t0, a1, t1
    li t1, 2
    mul t0, t0, t1
    add a0, t0, a0
    lh a0, 0(a0)
    ret

.globl middle_value_char
middle_value_char: 
    li t1, 2
    div t0, a1, t1
    add a0, t0, a0
    lb a0, 0(a0)
    ret

.globl value_matrix
value_matrix: 
    li t0, 42
    mul t2, a1, t0 
    add t2, t2, a2
    li t0, 4
    mul t2, t2, t0
    add a0, a0, t2
    lw a0, 0(a0)
    ret