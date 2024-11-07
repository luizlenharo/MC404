.data

.text
.globl operation
operation:
    add t0, a1, a2  #b + c
    sub t0, t0, a5  #b + c - f
    add t0, t0, a7  #b + c - f + h
    lw t1, 8(sp)    #k
    add t0, t0, t1  #b + c - f + h + k
    lw t1, 16(sp)   #m
    sub t0, t0, t1  #b + c - f + h + k - m
    mv a0, t0
    ret