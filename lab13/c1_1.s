.data
    my_var: .word 10

.text
.globl my_var
.globl increment_my_var

increment_my_var:
    la t0, my_var
    lw a0, 0(t0)
    addi a0, a0, 1
    sw a0, 0(t0)
    ret
